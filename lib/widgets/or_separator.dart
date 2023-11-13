import 'package:flutter/material.dart';

class OrSeparator extends StatelessWidget {
  const OrSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        SizedBox(width: 12.0),
        Text('or'),
        SizedBox(width: 12.0),
        Expanded(child: Divider()),
      ],
    );
  }
}
