import 'package:flutter/material.dart';
import '../models/partner.dart';

const partners = <Partner>[
  Partner(
    id: 'ntc',
    name: 'Nike Training Club',
    initial: 'NTC',
    desc: 'Nike Training Club는 TRACKSY의 활동 데이터를 다른 건강/피트니스 앱과 동기화 하여 더 나은 인사이트를 제공합니다.',
    logoBg: [Color(0xFF000000), Color(0xFF1F1F23)],
  ),
  Partner(
    id: 'garmin',
    name: 'Garmin Connect',
    initial: 'G',
    desc: 'Garmin Connect의 러닝 데이터를 TRACKSY로 가져와 한 곳에서 관리하세요.',
    logoBg: [Color(0xFF1B79F0), Color(0xFF005FB8)],
  ),
  Partner(
    id: 'coros',
    name: 'Coros',
    initial: 'C',
    desc: 'Coros 워치의 운동 기록을 TRACKSY와 동기화합니다.',
    logoBg: [Color(0xFFFF4500), Color(0xFFCC3300)],
  ),
  Partner(
    id: 'adidas',
    name: 'Adidas Running',
    initial: 'AR',
    desc: 'Adidas Running의 기록을 TRACKSY 카드로 멋지게 꾸며보세요.',
    logoBg: [Color(0xFF000000), Color(0xFF333333)],
  ),
  Partner(
    id: 'hc',
    name: 'Health Connect',
    initial: 'HC',
    desc: 'Health Connect를 통해 다양한 건강 앱과 데이터를 연동합니다.',
    logoBg: [Color(0xFFEA4335), Color(0xFFB52E22)],
  ),
  Partner(
    id: 'google',
    name: 'Google 피트니스',
    initial: 'G',
    desc: 'Google 피트니스의 활동 기록을 TRACKSY로 가져옵니다.',
    logoBg: [Color(0xFF4285F4), Color(0xFF34A853)],
  ),
  Partner(
    id: 'apple',
    name: 'Apple 건강',
    initial: '🍎',
    desc: 'Apple 건강 앱의 운동 기록을 TRACKSY와 연동합니다.',
    logoBg: [Color(0xFFEEEEEE), Color(0xFFCCCCCC)],
    logoFg: Color(0xFF000000),
  ),
];
