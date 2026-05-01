import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Mascot extends StatelessWidget {
  final double size;
  const Mascot({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset('assets/mascot.svg', fit: BoxFit.contain),
    );
  }
}
