import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmLogoutDialog extends StatelessWidget {
  const ConfirmLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm logout'),
      content: const Text('Are sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => context.pop(true),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
