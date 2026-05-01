import 'package:flutter/material.dart';

class StyleStat {
  final String value;
  final String label;
  const StyleStat(this.value, this.label);
}

class StyleCardData {
  final String id;
  final String date;
  final String title;
  final String dist;
  final Color distColor;
  final List<Color> bg;
  final List<StyleStat> stats;

  const StyleCardData({
    required this.id,
    required this.date,
    required this.title,
    required this.dist,
    required this.distColor,
    required this.bg,
    required this.stats,
  });
}

class GalleryCardData {
  final int id;
  final String date;
  final String title;
  final String dist;
  final String pace;
  final String time;
  final int kcal;
  final String elev;
  final int bpm;
  final int cadence;
  final int likes;
  final int comments;
  final List<Color> bg;

  const GalleryCardData({
    required this.id,
    required this.date,
    required this.title,
    required this.dist,
    required this.pace,
    required this.time,
    required this.kcal,
    required this.elev,
    required this.bpm,
    required this.cadence,
    required this.likes,
    required this.comments,
    required this.bg,
  });
}
