import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../state/studio_store.dart';
import '../theme/colors.dart';
import '../widgets/running_card.dart';
import '../widgets/toast.dart';

class StudioScreen extends StatelessWidget {
  const StudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studio = context.watch<StudioStore>();
    final nav = context.read<NavController>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => nav.back(),
              ),
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: () => showToast(context, '실행취소'),
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                onPressed: () => showToast(context, '다시실행'),
              ),
              IconButton(
                icon: const Icon(Icons.layers_outlined),
                onPressed: () => showToast(context, '레이어'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => nav.go('studioExport'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                ),
                child: const Text('내보내기',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Stack(
              children: [
                const Center(child: RunningCard()),
                Positioned(
                  right: 0,
                  bottom: 12,
                  child: FloatingActionButton.small(
                    onPressed: () => showToast(context, '스티커 추가'),
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    child: const Icon(Icons.add_reaction_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Tool panel
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: _StudioPanel(tab: studio.tab),
        ),
        // Tab bar
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.borderSoft)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Tab(icon: Icons.edit_outlined, label: '편집', active: studio.tab == 'edit', onTap: () => studio.setTab('edit')),
              _Tab(label: '텍스트', textGlyph: 'Tr', active: studio.tab == 'text', onTap: () => studio.setTab('text')),
              _Tab(icon: Icons.emoji_emotions_outlined, label: '스티커', active: studio.tab == 'sticker', onTap: () => studio.setTab('sticker')),
              _Tab(icon: Icons.palette_outlined, label: '디자인', active: studio.tab == 'design', onTap: () => studio.setTab('design')),
            ],
          ),
        ),
      ],
    );
  }
}

class _StudioPanel extends StatelessWidget {
  final String tab;
  const _StudioPanel({required this.tab});

  @override
  Widget build(BuildContext context) {
    if (tab == 'edit') {
      return _toolGrid(context, [
        ('잘라내기', Icons.crop),
        ('회전', Icons.rotate_right),
        ('좌우 반전', Icons.flip),
        ('상하 반전', Icons.swap_vert),
        ('색을 수정', Icons.color_lens_outlined),
      ]);
    }
    if (tab == 'text') {
      return _toolGrid(context, [
        ('글꼴', null),
        ('글자크기', null),
        ('색상', null),
      ], glyphs: ['Aa', 'Tr', '🎨']);
    }
    if (tab == 'sticker') {
      const stickers = ['🏃','💜','✨','🔥','🎯','⚡','🏆','❤️','🌟','😊','🎉','💪'];
      return SizedBox(
        height: 96,
        child: GridView.count(
          crossAxisCount: 6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: stickers
              .map((s) => InkWell(
                    onTap: () => showToast(context, '$s 추가됨'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(s, style: const TextStyle(fontSize: 22)),
                    ),
                  ))
              .toList(),
        ),
      );
    }
    if (tab == 'design') {
      return _toolGrid(context, [
        ('테마컬러', Icons.color_lens_outlined),
        ('스타일', Icons.style_outlined),
        ('배경', Icons.image_outlined),
      ], onTap: (i) {
        if (i == 2) context.read<NavController>().go('studioBg');
      });
    }
    return const SizedBox.shrink();
  }

  Widget _toolGrid(
    BuildContext context,
    List<(String, IconData?)> items, {
    List<String>? glyphs,
    void Function(int)? onTap,
  }) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final (label, icon) = items[i];
          return InkWell(
            onTap: () {
              if (onTap != null) {
                onTap(i);
              } else {
                showToast(context, label);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: glyphs != null && i < glyphs.length
                      ? Text(glyphs[i], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900))
                      : Icon(icon, size: 22, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(label, style: const TextStyle(fontSize: 11)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData? icon;
  final String? textGlyph;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({this.icon, this.textGlyph, required this.label, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.textSoft;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, color: color, size: 22),
            if (textGlyph != null)
              Text(textGlyph!,
                  style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
