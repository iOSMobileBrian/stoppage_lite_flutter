import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoppage_lite/Services/child_service.dart';
import 'package:stoppage_lite/Widgets/child_avatar.dart';

class ChildSelectPage extends StatelessWidget {
  const ChildSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ChildService>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Select Child'),
      ),
      body: Column(
        children: [
          Expanded(
            child: service.children.isEmpty
                ? const Center(
                    child: Text(
                      'No children added yet.\nAdd children from the manage screen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: service.children.length,
                    itemBuilder: (context, index) {
                      final child = service.children[index];
                      final isSelected =
                          service.selectedChild?.id == child.id;
                      return GestureDetector(
                        onTap: () {
                          service.selectChild(child);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? Colors.blue.withValues(alpha: 0.3)
                                : Colors.grey[900],
                            border: isSelected
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChildAvatar(emoji: child.avatar, size: 56),
                              const SizedBox(height: 8),
                              Text(
                                child.name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  service.selectChild(null);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Skip (no child)',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
