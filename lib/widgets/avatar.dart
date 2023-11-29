import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Avatar extends StatelessWidget {
  final dynamic image;
  final double radius;

  const Avatar({
    required this.image,
    this.radius = 64,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.secondaryContainer,
      child: image == null
          ? null
          : ClipOval(
              child: image.runtimeType == String
                  ? SvgPicture.string(
                      image,
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                    )
                  : Image.memory(
                      image,
                    ),
            ),
    );
  }
}
