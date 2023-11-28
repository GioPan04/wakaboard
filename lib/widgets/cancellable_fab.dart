import 'package:flutter/material.dart';

class CancellableFAB extends StatelessWidget {
  final VoidCallback onPrimaryTapped;
  final VoidCallback onCancelTapped;
  final Widget primary;
  final Widget cancel;
  final bool open;

  const CancellableFAB({
    required this.onPrimaryTapped,
    required this.onCancelTapped,
    required this.primary,
    required this.cancel,
    required this.open,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubicEmphasized,
            bottom: open ? 116 : 24,
            right: 24,
            child: FloatingActionButton.small(
              backgroundColor: theme.colorScheme.onSecondary,
              onPressed: onCancelTapped,
              heroTag: "Cancel FAB",
              child: cancel,
            ),
          ),
          FloatingActionButton.large(
            onPressed: onPrimaryTapped,
            child: primary,
          ),
        ],
      ),
    );
  }
}
