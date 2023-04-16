import 'package:flutter/material.dart';

class MultiSelectHeader extends StatelessWidget {
  const MultiSelectHeader({
    super.key,
    required this.title,
    required this.onReset,
  });

  final String title;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title),
        TextButton(
          onPressed: onReset,
          child: Text(
            'Reset',
            style: TextStyle(color: Colors.green.shade800),
          ),
        ),
      ],
    );
  }
}
