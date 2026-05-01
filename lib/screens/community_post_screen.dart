import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/sample_community.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/toast.dart';

class CommunityPostScreen extends StatelessWidget {
  final int id;
  const CommunityPostScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final post = communityPosts.firstWhere((p) => p.id == id, orElse: () => communityPosts.first);
    final avatar = post.avatarGradient ?? const [Color(0xFFA78BFA), Color(0xFF7C3AED)];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => context.read<NavController>().back(),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: avatar, begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
              ),
              const SizedBox(width: 8),
              Text(post.user ?? '박채원', style: const TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(
                onPressed: () => showToast(context, '저장됨'),
                icon: const Icon(Icons.bookmark_border),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              AspectRatio(
                aspectRatio: 9 / 14,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: post.bgGradient,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('글쓴날 오전 9:41',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(post.dist ?? '6.06',
                          style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900, height: 1)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _stat("5'48\"", '페이스'),
                          _stat('46:45', '시간'),
                          _stat('154', 'kcal'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _stat('25 m', '고도', sub: true),
                          _stat('152', '심박', sub: true),
                          _stat('173', '케이던스', sub: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('오늘 날씨 진짜 좋다 - !!!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('@ 오공원 # 무이용 # 야자스',
                  style: TextStyle(color: AppColors.primaryDark, fontSize: 13)),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Text('4시간 전', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  SizedBox(width: 12),
                  Text('❤️ 563', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 8),
                  Text('💬 120', style: TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _ActBtn(label: '⭐ 즐겨찾기', primary: false,
                        onTap: () => showToast(context, '즐겨찾기에 추가했어요')),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActBtn(label: '✨ 이 템플릿 사용하기', primary: true,
                        onTap: () => showToast(context, '템플릿을 적용했어요')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stat(String v, String l, {bool sub = false}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(v,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: sub ? 12 : 16,
                  fontWeight: FontWeight.w800)),
          Text(l, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}

class _ActBtn extends StatelessWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;
  const _ActBtn({required this.label, required this.primary, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary ? AppColors.primary : AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: primary ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
