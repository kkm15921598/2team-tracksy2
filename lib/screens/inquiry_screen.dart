import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/inquiry_store.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';

class InquiryScreen extends StatefulWidget {
  const InquiryScreen({super.key});
  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  String _type = '서비스 이용';
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _submit() {
    if (_title.text.trim().isEmpty || _body.text.trim().isEmpty) {
      showToast(context, '제목과 내용을 입력해주세요');
      return;
    }
    final inq = context.read<InquiryStore>().add(
          type: _type,
          title: _title.text.trim(),
          body: _body.text.trim(),
        );
    showToast(context, '문의가 등록되었어요');
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) context.read<NavController>().go('inquiryDetail:${inq.id}', replace: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(title: '이용문의'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('무엇을 도와드릴까요?',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 4),
                          Text('문의하시면 확인 후 답변해드릴게요.',
                              style: TextStyle(color: AppColors.textSoft, fontSize: 13)),
                        ],
                      ),
                    ),
                    const Text('📮', style: TextStyle(fontSize: 38)),
                  ],
                ),
                const SizedBox(height: 24),
                _label('문의유형'),
                Wrap(
                  spacing: 8,
                  children: ['서비스 이용', '계정/로그인', '기타'].map((v) {
                    final sel = _type == v;
                    return ChoiceChip(
                      label: Text(v),
                      selected: sel,
                      selectedColor: AppColors.primarySoft,
                      labelStyle: TextStyle(
                        color: sel ? AppColors.primaryDark : AppColors.textPrimary,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                      ),
                      onSelected: (_) => setState(() => _type = v),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                _label('제목'),
                TextField(
                  controller: _title,
                  decoration: const InputDecoration(hintText: '제목을 입력하세요'),
                ),
                const SizedBox(height: 16),
                _label('내용'),
                TextField(
                  controller: _body,
                  maxLines: 6,
                  decoration: const InputDecoration(hintText: '문의하실 내용을 자세히 적어주세요'),
                ),
                const SizedBox(height: 24),
                PrimaryButton(label: '문의 완료하기', onPressed: _submit),
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
