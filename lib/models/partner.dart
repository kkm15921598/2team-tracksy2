import 'package:flutter/material.dart';

class Partner {
  final String id;
  final String name;
  final String initial;
  final String desc;
  final List<Color> logoBg;
  final Color logoFg;

  const Partner({
    required this.id,
    required this.name,
    required this.initial,
    required this.desc,
    required this.logoBg,
    this.logoFg = Colors.white,
  });
}
