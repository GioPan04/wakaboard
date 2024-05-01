import 'package:flutter/material.dart';

class Typewriter extends StatelessWidget {
  final Animation<double> anim;
  final String text;
  final TextStyle? style;

  const Typewriter({
    required this.anim,
    required this.text,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        final currentLength = (text.length * anim.value).ceil();

        return Text(
          text.substring(0, currentLength),
          style: style,
        );
      },
    );
  }
}
