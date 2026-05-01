import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  static const _homeRoutes = {
    'profile', 'profileEdit', 'settings', 'partners', 'partnerDetail',
    'inquiry', 'inquiryDetail', 'inquiryList', 'feedback',
  };
  static const _commRoutes = {'communityPost', 'communityCompose'};
  static const _archiveRoutes = {
    'archiveManual', 'archiveSync', 'archiveScan', 'archiveAI',
  };

  String _activeKey(String route) {
    final base = route.split(':').first;
    if (base == 'home' || _homeRoutes.contains(base)) return 'home';
    if (base == 'community' || _commRoutes.contains(base)) return 'community';
    if (base == 'archive' || _archiveRoutes.contains(base)) return 'archive';
    if (base == 'studio') return 'studio';
    if (base == 'record') return 'record';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavController>();
    final active = _activeKey(nav.top);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderSoft)),
      ),
      padding: const EdgeInsets.only(top: 6, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            label: '홈',
            active: active == 'home',
            onTap: () => context.read<NavController>().resetTo('home'),
          ),
          _NavItem(
            icon: Icons.image_outlined,
            label: '스튜디오',
            active: active == 'studio',
            onTap: () => context.read<NavController>().resetTo('studio'),
          ),
          _FabItem(
            active: active == 'record',
            onTap: () => context.read<NavController>().resetTo('record'),
          ),
          _NavItem(
            icon: Icons.people_outline,
            label: '커뮤니티',
            active: active == 'community',
            onTap: () => context.read<NavController>().resetTo('community'),
          ),
          _NavItem(
            icon: Icons.folder_outlined,
            label: '보관함',
            active: active == 'archive',
            onTap: () => context.read<NavController>().resetTo('archive'),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textMuted;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabItem extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  const _FabItem({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 2),
            Text(
              '기록',
              style: TextStyle(
                fontSize: 11,
                color: active ? AppColors.primary : AppColors.textMuted,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
