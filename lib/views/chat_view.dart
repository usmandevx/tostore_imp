import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../services/tostore_service.dart';

class ChatView extends StatefulWidget {
  final User user;
  const ChatView({super.key, required this.user});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final Stream<List<Message>> _stream;
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _stream = ToStoreService.instance.messagesStream(widget.user.id);
    _loadInitialMessages();
  }

  Future<void> _loadInitialMessages() async {
    final msgs = await ToStoreService.instance.getMessagesWith(widget.user.id);
    setState(() {
      _messages = msgs;
    });
    _scrollToEnd();
    _stream.listen((msgs) {
      setState(() {
        _messages = msgs;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
    });
  }

  void _scrollToEnd() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future<void> _send() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: 'You',
      text: text,
      createdAt: DateTime.now(),
    );
    _textController.clear();
    await ToStoreService.instance.sendMessage(widget.user.id, msg);
  }

  Future<void> _clear() async {
    await ToStoreService.instance.clearChat(widget.user.id);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.user.name}'),
        actions: [
          IconButton(onPressed: _clear, icon: const Icon(Icons.delete_forever)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isMe = m.sender == 'You';
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Card(
                    color: isMe ? Colors.teal[100] : Colors.grey[200],
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.sender,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(m.text),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              TimeOfDay.fromDateTime(
                                m.createdAt,
                              ).format(context),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _send, child: const Text('Send')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
