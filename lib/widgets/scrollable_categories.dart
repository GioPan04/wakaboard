import 'package:flutter/material.dart';

class ScrollableCategories<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T item) getLabel;
  final bool Function(T item) selected;
  final void Function(T item) onItemPressed;
  final double horizontalPadding;
  final bool stopPropagation;

  const ScrollableCategories({
    required this.items,
    required this.getLabel,
    required this.onItemPressed,
    required this.selected,
    this.horizontalPadding = 16.0,
    this.stopPropagation = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: NotificationListener(
        // Stop the propagation of scrolling events, was catched by the top screen fab
        onNotification: (_) => stopPropagation,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, i) => Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? horizontalPadding : 0.0,
              right: i == items.length - 1 ? horizontalPadding : 0,
            ),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(getLabel(items[i])),
              selected: selected(items[i]),
              onSelected: (_) => onItemPressed(items[i]),
            ),
          ),
          separatorBuilder: (context, index) => const SizedBox(
            width: 12,
          ),
        ),
      ),
    );
  }
}
