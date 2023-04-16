import 'package:flutter/material.dart';

class SelectedOptionChip extends StatelessWidget {
  const SelectedOptionChip({
    super.key,
    required this.value,
    required this.onRemove,
  });

  final String value;
  final Function(String) onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            onTap: () => onRemove(value),
            child: const Icon(Icons.close),
          ),
          const SizedBox(width: 6),
          Text(value.toUpperCase())
        ],
      ),
    );
  }
}
