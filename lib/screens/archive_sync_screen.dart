import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/partners.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/toast.dart';
import 'partners_screen.dart';

class ArchiveSyncScreen extends StatelessWidget {
  const ArchiveSyncScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('타사 앱 데이터 연동하기',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    SizedBox(height: 2),
                    Text('연동할 앱을 선택해주세요.',
                        style: TextStyle(color: AppColors.textSoft, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.read<NavController>().back(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                for (final p in partners)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () => showToast(context, '${p.name} 연동을 시작했어요'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            partnerLogo(p, 38),
                            const SizedBox(width: 12),
                            Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                            const Icon(Icons.open_in_new, size: 18, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: const [
                      Text('🔒', style: TextStyle(fontSize: 26)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('연동은 안전하게 진행돼요',
                                style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                            SizedBox(height: 4),
                            Text('연동된 데이터는 안전하게 보호되며, 기록 저장에만 사용돼요.',
                                style: TextStyle(fontSize: 12, color: AppColors.textSoft, height: 1.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
