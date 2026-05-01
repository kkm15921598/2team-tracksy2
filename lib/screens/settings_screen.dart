import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.read<NavController>();
    return Column(
      children: [
        const AppHeader(title: '설정'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader('파트너 앱'),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => nav.go('partners'),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.cloud_sync_outlined, color: AppColors.primary),
                        SizedBox(width: 10),
                        Expanded(child: Text('파트너 APP 기록 가져오기', style: TextStyle(fontWeight: FontWeight.w600))),
                        Icon(Icons.chevron_right, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionHeader('고객 문의'),
                const SizedBox(height: 8),
                _ListItem(label: '이용 문의하기', onTap: () => nav.go('inquiry')),
                _ListItem(label: '나의 문의내역', onTap: () => nav.go('inquiryList')),
                _ListItem(label: '개선사항 보내기', onTap: () => nav.go('feedback')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSoft, fontWeight: FontWeight.w600));
  }
}

class _ListItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ListItem({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
