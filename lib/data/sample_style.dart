import 'package:flutter/material.dart';
import '../models/style_card.dart';

const savedStyles = <StyleCardData>[
  StyleCardData(
    id: 's1',
    date: '오늘 · 5.21 (화)',
    title: '올림픽 공원 러닝',
    dist: '6.06',
    distColor: Color(0xFF1F1F23),
    bg: [Color(0xFFA8D8B9), Color(0xFF7FB68C), Color(0xFF5C8A6E), Color(0xFF3F5E55)],
    stats: [
      StyleStat("7'43\"", '평균 페이스'),
      StyleStat('46:45', '시간'),
      StyleStat('154', 'BPM'),
      StyleStat('25m', '누적 상승'),
      StyleStat('152', '평균 케이던스'),
      StyleStat('173', '칼로리'),
    ],
  ),
  StyleCardData(
    id: 's2',
    date: '2024. 04. 02 (화)',
    title: '벚꽃 러닝',
    dist: '10.02',
    distColor: Color(0xFFE11D48),
    bg: [Color(0xFFFFD7E1), Color(0xFFF5A6BB), Color(0xFFD87693), Color(0xFF9C5670)],
    stats: [
      StyleStat("6'12\"", '평균 페이스'),
      StyleStat('1:02:15', '시간'),
      StyleStat('632', '칼로리'),
      StyleStat('45m', '누적 상승'),
      StyleStat('148', '평균 케이던스'),
      StyleStat('160', '평균 심박'),
    ],
  ),
];

const myStyles = <StyleCardData>[
  StyleCardData(
    id: 'm1',
    date: '2024. 03. 18 (월)',
    title: '야간 러닝',
    dist: '5.23',
    distColor: Color(0xFFBEF264),
    bg: [Color(0xFF1F2937), Color(0xFF0F172A), Color(0xFF020617)],
    stats: [
      StyleStat("6'35\"", '평균 페이스'),
      StyleStat('34:20', '시간'),
      StyleStat('278', '칼로리'),
      StyleStat('18m', '누적 상승'),
      StyleStat('142', '평균 케이던스'),
      StyleStat('165', '평균 심박'),
    ],
  ),
  StyleCardData(
    id: 'm2',
    date: '2024. 05. 12 (일)',
    title: '한강 러닝 10K',
    dist: '5.23',
    distColor: Color(0xFF1F1F23),
    bg: [Color(0xFFFCD9A4), Color(0xFFE89E7A), Color(0xFF9C6B82), Color(0xFF3D3548)],
    stats: [
      StyleStat("6'35\"", '평균 페이스'),
      StyleStat('34:20', '시간'),
      StyleStat('278', '칼로리'),
      StyleStat('18m', '누적 상승'),
      StyleStat('142', '평균 케이던스'),
      StyleStat('165', '평균 심박'),
    ],
  ),
];
