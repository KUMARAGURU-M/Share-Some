import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;

  const SquareTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const ShapeDecoration(
        shape: OvalBorder(
          side: BorderSide(width: 1, color: Color(0xFFE6E6E6)),
        ),
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }
}
