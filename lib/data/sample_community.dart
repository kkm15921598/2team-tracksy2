import 'package:flutter/material.dart';
import '../models/post.dart';

const communityPosts = <CommunityPost>[
  CommunityPost(
    id: 1,
    type: PostType.photo,
    dist: '5km/1km',
    time: '2m 50s',
    likes: 154,
    brand: 'STRAVA',
    bgGradient: [Color(0xFFA8D8EA), Color(0xFF7AB8C9), Color(0xFF5C8FA8)],
    tall: true,
  ),
  CommunityPost(
    id: 2,
    type: PostType.photo,
    dist: '6.06',
    user: '박채원',
    likes: 563,
    bgGradient: [Color(0xFF87CEEB), Color(0xFFA8D08D), Color(0xFF7BA876)],
    avatarGradient: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
  ),
  CommunityPost(
    id: 3,
    type: PostType.stats,
    user: '이용곡',
    dist: '11.00',
    likes: 138,
    bgGradient: [Color(0xFFFECACA), Color(0xFFFCA5A5)],
    pace: "0'34\"",
    time: "1'22\"",
    cal: '586',
    extra: '21m...',
  ),
  CommunityPost(
    id: 4,
    type: PostType.photo,
    user: '이용민',
    time: '3m 0s',
    likes: 92,
    bgGradient: [Color(0xFFDDD6FE), Color(0xFFA78BFA)],
    tall: true,
  ),
  CommunityPost(
    id: 5,
    type: PostType.photo,
    dist: '4.20',
    likes: 211,
    bgGradient: [Color(0xFFFED7AA), Color(0xFFFB923C)],
  ),
  CommunityPost(
    id: 6,
    type: PostType.photo,
    dist: '7.15',
    user: '러너준',
    likes: 87,
    bgGradient: [Color(0xFFA7F3D0), Color(0xFF34D399)],
    tall: true,
  ),
];

class Collection {
  final String title;
  final String emoji;
  final List<Color> gradient;
  const Collection({required this.title, required this.emoji, required this.gradient});
}

const collections = <Collection>[
  Collection(title: '오늘 러닝 무드', emoji: '☁️', gradient: [Color(0xFF9CA3AF), Color(0xFF4B5563)]),
  Collection(title: '데일리 러닝', emoji: '🏆', gradient: [Color(0xFFFBBF24), Color(0xFFF59E0B)]),
  Collection(title: '야경 러닝', emoji: '🌙', gradient: [Color(0xFF1E3A8A), Color(0xFF312E81)]),
  Collection(title: '감성 러닝', emoji: '💜', gradient: [Color(0xFFA78BFA), Color(0xFF7C3AED)]),
];
