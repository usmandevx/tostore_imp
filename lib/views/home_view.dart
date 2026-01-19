import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/tostore_service.dart';
import 'chat_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<User> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await ToStoreService.instance.getUsers();
    setState(() {
      _users = users;
      _loading = false;
    });
  }

  Future<String> _getPreview(User user) async {
    final m = await ToStoreService.instance.getLastMessageFor(user.id);
    if (m == null) return 'No messages yet';
    return '${m.sender}: ${m.text}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox (Local)'),
        actions: [
          IconButton(onPressed: _loadUsers, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _users.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = _users[index];
                return FutureBuilder<String>(
                  future: _getPreview(user),
                  builder: (context, snap) {
                    final subtitle = snap.data ?? 'Loading...';
                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatView(user: user),
                          ),
                        );
                        _loadUsers();
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
