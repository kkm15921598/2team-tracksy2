import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _t = TextEditingController();
  final _b = TextEditingController();

  @override
  void dispose() {
    _t.dispose();
    _b.dispose();
    super.dispose();
  }

  void _send() {
    if (_t.text.trim().isEmpty || _b.text.trim().isEmpty) {
      showToast(context, '제목과 내용을 입력해주세요');
      return;
    }
    showToast(context, '소중한 의견 감사합니다!');
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) context.read<NavController>().back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(title: '개선사항'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '더 나은 서비스를\n만들어가는데 도움을 주세요!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, height: 1.4),
                ),
                const SizedBox(height: 6),
                const Text(
                  '여러분의 소중한 의견이 트랙시의\n더 좋은 서비스를 만들어갑니다.',
                  style: TextStyle(color: AppColors.textSoft, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 24),
                _label('제목'),
                TextField(controller: _t, decoration: const InputDecoration(hintText: '제목을 입력하세요')),
                const SizedBox(height: 16),
                _label('내용'),
                TextField(
                  controller: _b,
                  maxLines: 6,
                  decoration: const InputDecoration(hintText: '개선되었으면 하는 부분을 자유롭게 적어주세요'),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('안내사항', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                      SizedBox(height: 6),
                      Text('• 보내주신 의견은 서비스 개선에 적극 반영할게요.',
                          style: TextStyle(fontSize: 12, height: 1.6)),
                      Text('• 모든 의견에 개별 답변이 어려운 점 양해부탁드립니다.',
                          style: TextStyle(fontSize: 12, height: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(label: '의견 보내기', onPressed: _send),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      );
}
