import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../state/studio_store.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/running_card.dart';
import '../widgets/toast.dart';

class StudioBgScreen extends StatelessWidget {
  const StudioBgScreen({super.key});

  static const _swatches = <List<Color>>[
    [Color(0xFFFFD89B), Color(0xFF19547B)],
    [Color(0xFFFFAFBD), Color(0xFFFFC3A0)],
    [Color(0xFF1F4037), Color(0xFF99F2C8)],
    [Color(0xFFE0E0E0), Color(0xFFB0B0B0)],
    [Color(0xFFFCE38A), Color(0xFFF38181)],
    [Color(0xFF7B6499), Color(0xFF2E2A3D)],
  ];

  @override
  Widget build(BuildContext context) {
    final studio = context.watch<StudioStore>();
    final selected = studio.bgPickedIndex ?? 0;
    final bg = _swatches[selected];
    return Column(
      children: [
        const AppHeader(title: '배경 변경'),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 320,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: RunningCard(small: true, bgGradient: bg),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _BgTab(
                        label: '내 사진',
                        active: studio.bgPickerTab == 'mine',
                        onTap: () => studio.setBgTab('mine'),
                      ),
                      const SizedBox(width: 8),
                      _BgTab(
                        label: 'AI추천',
                        active: studio.bgPickerTab == 'ai',
                        onTap: () => studio.setBgTab('ai'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: _swatches.length,
                    itemBuilder: (context, i) {
                      final s = _swatches[i];
                      return InkWell(
                        onTap: () => studio.pickBg(i),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: s,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: i == selected
                              ? Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: AppColors.primary, size: 18),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PrimaryButton(
                    label: '배경 적용하기',
                    onPressed: () {
                      showToast(context, '배경이 적용되었어요');
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (context.mounted) context.read<NavController>().back();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BgTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _BgTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          border: Border.all(color: active ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.textPrimary,
            fontSize: 13,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
