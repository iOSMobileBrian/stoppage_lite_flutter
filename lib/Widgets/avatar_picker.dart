import 'package:flutter/material.dart';
import 'package:stoppage_lite/Constants/timer_constants.dart';

class AvatarPicker extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelected;

  const AvatarPicker({Key? key, this.selected, required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: kAvatarOptions.length,
      itemBuilder: (context, index) {
        final emoji = kAvatarOptions[index];
        final isSelected = emoji == selected;
        return GestureDetector(
          onTap: () => onSelected(emoji),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.blue : Colors.grey[800],
              border: isSelected
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
        );
      },
    );
  }
}
