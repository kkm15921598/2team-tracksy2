import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/sample_community.dart';
import '../models/post.dart';
import '../state/community_store.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/toast.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<CommunityStore>();
    final nav = context.read<NavController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, size: 18, color: AppColors.textSoft),
                      SizedBox(width: 6),
                      Text('#오운완  #생활런  #응원해',
                          style: TextStyle(color: AppColors.textSoft, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.bookmark_border, size: 18),
                  onPressed: () => showToast(context, '저장됨'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Tab(label: 'Hot', active: store.tab == 'hot', onTap: () => store.setTab('hot')),
              const SizedBox(width: 16),
              _Tab(label: 'New', active: store.tab == 'new', onTap: () => store.setTab('new')),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Text('인기 모음집 👟',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const Spacer(),
              InkWell(
                onTap: () => nav.go('communityCompose'),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.add, size: 14, color: AppColors.primaryDark),
                      SizedBox(width: 4),
                      Text('글쓰기',
                          style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
            children: collections.map((c) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: c.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(c.title,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                    Text(c.emoji, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          // Masonry feed: 2 columns alternating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    for (int i = 0; i < communityPosts.length; i += 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _FeedCard(post: communityPosts[i]),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    for (int i = 1; i < communityPosts.length; i += 2)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _FeedCard(post: communityPosts[i]),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: active ? FontWeight.w900 : FontWeight.w500,
                    color: active ? AppColors.textPrimary : AppColors.textMuted)),
            const SizedBox(height: 4),
            Container(
              width: 22,
              height: 3,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  final CommunityPost post;
  const _FeedCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final aspect = post.tall ? 0.6 : 0.85;
    return InkWell(
      onTap: () => context.read<NavController>().go('communityPost:${post.id}'),
      borderRadius: BorderRadius.circular(14),
      child: AspectRatio(
        aspectRatio: aspect,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: post.bgGradient,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              if (post.type == PostType.stats) ..._stats(),
              if (post.type == PostType.photo) ..._photo(),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => showToast(context, '저장됨'),
                  child: const Icon(Icons.bookmark_border, color: Colors.white, size: 18),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Text('❤ ${post.likes}',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _photo() {
    return [
      Positioned(
        top: 4,
        left: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.brand != null)
              Text(post.brand!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
            if (post.dist != null)
              Text(post.dist!, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
            if (post.time != null)
              Text(post.time!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            if (post.user != null)
              Text(post.user!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ];
  }

  List<Widget> _stats() {
    return [
      Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (post.user != null)
                Text(post.user!,
                    style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(post.dist ?? '',
                  style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (post.pace != null) _miniStat(post.pace!, '페이스'),
                  if (post.time != null) _miniStat(post.time!, '시간'),
                  if (post.cal != null) _miniStat(post.cal!, 'kcal'),
                  if (post.extra != null) _miniStat(post.extra!, '거리'),
                ],
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _miniStat(String v, String l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(v, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
        Text(l, style: const TextStyle(fontSize: 9, color: Colors.black54)),
      ],
    );
  }
}
