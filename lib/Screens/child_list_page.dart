import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoppage_lite/Constants/timer_constants.dart';
import 'package:stoppage_lite/Models/child_profile.dart';
import 'package:stoppage_lite/Screens/child_history_page.dart';
import 'package:stoppage_lite/Services/child_service.dart';
import 'package:stoppage_lite/Widgets/avatar_picker.dart';
import 'package:stoppage_lite/Widgets/child_avatar.dart';

class ChildListPage extends StatelessWidget {
  const ChildListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChildService>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Children'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showChildDialog(context),
        child: const Icon(Icons.add),
      ),
      body: service.children.isEmpty
          ? const Center(
              child: Text(
                'No children added yet.\nTap + to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: service.children.length,
              itemBuilder: (context, index) {
                final child = service.children[index];
                return ListTile(
                  leading: ChildAvatar(emoji: child.avatar),
                  title: Text(
                    child.name,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.grey),
                        onPressed: () =>
                            _showChildDialog(context, existing: child),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () =>
                            _confirmDelete(context, service, child),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChildHistoryPage(child: child),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(
      BuildContext context, ChildService service, ChildProfile child) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Child'),
        content: Text(
            'Delete ${child.name} and all their timeout logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              service.deleteChild(child.id);
              Navigator.pop(ctx);
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChildDialog(BuildContext context, {ChildProfile? existing}) {
    final nameController =
        TextEditingController(text: existing?.name ?? '');
    String selectedAvatar = existing?.avatar ?? kAvatarOptions.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(existing == null ? 'Add Child' : 'Edit Child'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Avatar',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                AvatarPicker(
                  selected: selectedAvatar,
                  onSelected: (emoji) {
                    setDialogState(() => selectedAvatar = emoji);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                final service =
                    Provider.of<ChildService>(context, listen: false);
                if (existing == null) {
                  service.addChild(ChildProfile(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    avatar: selectedAvatar,
                  ));
                } else {
                  service.updateChild(
                      existing.copyWith(name: name, avatar: selectedAvatar));
                }
                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
