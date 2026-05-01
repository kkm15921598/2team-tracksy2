import 'package:flutter/material.dart';

enum PostType { photo, stats }

class CommunityPost {
  final int id;
  final PostType type;
  final String? dist;
  final String? time;
  final String? user;
  final String? brand;
  final int likes;
  final List<Color> bgGradient;
  final List<Color>? avatarGradient;
  final bool tall;
  final String? pace;
  final String? cal;
  final String? extra;

  const CommunityPost({
    required this.id,
    required this.type,
    this.dist,
    this.time,
    this.user,
    this.brand,
    required this.likes,
    required this.bgGradient,
    this.avatarGradient,
    this.tall = false,
    this.pace,
    this.cal,
    this.extra,
  });
}
