import 'dart:async';

import 'package:tostore/tostore.dart';

import '../models/message.dart';
import '../models/user.dart';

class ToStoreService {
  ToStoreService._private();
  static final ToStoreService instance = ToStoreService._private();

  late final ToStore db;

  // Stream controllers per user chat id
  final Map<String, StreamController<List<Message>>> _controllers = {};

  Future<void> init({String dbName = 'tostore_db_v2'}) async {
    final userSchema = TableSchema(
      name: 'users',
      primaryKeyConfig: PrimaryKeyConfig(name: 'id'),
      fields: [FieldSchema(name: 'name', type: DataType.text)],
    );
    final messageSchema = TableSchema(
      name: 'messages',
      primaryKeyConfig: PrimaryKeyConfig(name: 'id'),
      fields: [
        FieldSchema(name: 'sender', type: DataType.text),
        FieldSchema(name: 'text', type: DataType.text),
        FieldSchema(name: 'createdAt', type: DataType.text),
        FieldSchema(name: 'userId', type: DataType.text),
      ],
      indexes: [
        IndexSchema(indexName: 'user_idx', fields: ['userId']),
      ],
    );
    db = ToStore(dbName: dbName, schemas: [userSchema, messageSchema]);
    await db.initialize();
    await _ensureInbox();
  }

  Future<void> _ensureInbox() async {
    final existing = await db.query('users');
    if (existing.isEmpty) {
      final users = List.generate(
        10,
        (i) => User(id: '${i + 1}', name: 'User ${i + 1}'),
      );
      for (final user in users) {
        await db.insert('users', user.toJson());
      }
    }
  }

  Future<List<User>> getUsers() async {
    final query = db.query('users');
    final results = await query;
    return results.data.map((row) => User.fromJson(row)).toList();
  }

  Future<List<Message>> getMessagesWith(String userId) async {
    final query = db
        .query('messages')
        .where('userId', '=', userId)
        .orderByAsc('createdAt');
    final results = await query;
    return results.data.map((row) => Message.fromJson(row)).toList();
  }

  Stream<List<Message>> messagesStream(String userId) {
    if (!_controllers.containsKey(userId)) {
      _controllers[userId] = StreamController<List<Message>>.broadcast();
    }
    return _controllers[userId]!.stream;
  }

  Future<void> sendMessage(String userId, Message message) async {
    final data = {...message.toJson(), 'userId': userId};
    await db.insert('messages', data);

    // notify listeners
    final msgs = await getMessagesWith(userId);
    final ctrl = _controllers[userId];
    if (ctrl != null && !ctrl.isClosed) {
      ctrl.add(msgs);
    }
  }

  Future<void> clearChat(String userId) async {
    await db.delete('messages').where('userId', '=', userId);
    final ctrl = _controllers[userId];
    if (ctrl != null && !ctrl.isClosed) {
      ctrl.add([]);
    }
  }

  Future<Message?> getLastMessageFor(String userId) async {
    final query = db
        .query('messages')
        .where('userId', '=', userId)
        .orderByDesc('createdAt')
        .limit(1);
    final results = await query;
    if (results.data.isEmpty) return null;
    return Message.fromJson(results.data.first);
  }
}
