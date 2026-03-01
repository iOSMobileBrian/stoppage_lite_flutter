import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stoppage_lite/Models/child_profile.dart';
import 'package:stoppage_lite/Services/child_service.dart';
import 'package:stoppage_lite/Widgets/child_avatar.dart';

class ChildHistoryPage extends StatelessWidget {
  final ChildProfile child;

  const ChildHistoryPage({Key? key, required this.child}) : super(key: key);

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChildService>(context);
    final logs = service.logsForChild(child.id);
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            ChildAvatar(emoji: child.avatar, size: 32),
            const SizedBox(width: 8),
            Text(child.name),
          ],
        ),
      ),
      body: logs.isEmpty
          ? const Center(
              child: Text(
                'No timeouts recorded yet.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Dismissible(
                  key: Key(log.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => service.deleteLog(log.id),
                  child: ListTile(
                    leading: const Icon(Icons.timer,
                        color: Colors.orange, size: 32),
                    title: Text(
                      _formatDuration(log.durationSeconds),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${dateFormat.format(log.dateTime)} at ${timeFormat.format(log.dateTime)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
