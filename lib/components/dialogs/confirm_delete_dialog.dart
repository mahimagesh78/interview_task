import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String userName;
  final VoidCallback onConfirm;

  const ConfirmDeleteDialog({
    super.key,
    required this.userName,
    required this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String userName,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        userName: userName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete User'),
      content: Text(
        'Are you sure you want to delete "$userName"?\nThis action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
