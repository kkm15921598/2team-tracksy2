import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/toast.dart';

class ArchiveScanScreen extends StatelessWidget {
  const ArchiveScanScreen({super.key});

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
                    Text('캡쳐사진 스캔하기',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    SizedBox(height: 2),
                    Text('러닝 기록 캡쳐 사진을 업로드해주세요.',
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
          const SizedBox(height: 14),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('지원 예시',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _example([const Color(0xFFDBEAFE), const Color(0xFFBFDBFE)], '🗺'),
                      const SizedBox(width: 8),
                      _example([const Color(0xFF1F2937), const Color(0xFF111827)], '📊', dark: true),
                      const SizedBox(width: 8),
                      _example([const Color(0xFFFEF3C7), const Color(0xFFFDE68A)], '📝'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => showToast(context, '사진을 선택해주세요'),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 38),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primary, style: BorderStyle.solid, width: 1.5),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 50),
                          SizedBox(height: 8),
                          Text('캡쳐 사진 업로드',
                              style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('TIP', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w900)),
                        SizedBox(height: 4),
                        Text('기록이 잘 보이도록 캡쳐해주세요.\n거리, 시간, 페이스가 보이면 인식이 더 잘 돼요.',
                            style: TextStyle(fontSize: 12, height: 1.6, color: AppColors.textSoft)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _example(List<Color> bg, String emoji, {bool dark = false}) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 9 / 14,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(colors: bg, begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
}
