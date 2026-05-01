import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';

class ArchiveManualScreen extends StatefulWidget {
  const ArchiveManualScreen({super.key});
  @override
  State<ArchiveManualScreen> createState() => _ArchiveManualScreenState();
}

class _ArchiveManualScreenState extends State<ArchiveManualScreen> {
  final _date = TextEditingController();
  final _dist = TextEditingController();
  final _time = TextEditingController();
  final _pace = TextEditingController();
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _note.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _date.dispose();
    _dist.dispose();
    _time.dispose();
    _pace.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (_date.text.trim().isEmpty || _dist.text.trim().isEmpty) {
      showToast(context, '날짜와 거리는 필수예요');
      return;
    }
    showToast(context, '기록을 저장했어요');
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) context.read<NavController>().back();
    });
  }

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
                    Text('데이터 직접 입력하기',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    SizedBox(height: 2),
                    Text('직접 러닝 기록을 입력해 보세요.',
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
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('날짜'),
                    TextField(
                      controller: _date,
                      decoration: const InputDecoration(
                        hintText: '입력하기',
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _label('거리'),
                    TextField(controller: _dist, decoration: const InputDecoration(hintText: '입력하기')),
                    const SizedBox(height: 14),
                    _label('시간'),
                    TextField(controller: _time, decoration: const InputDecoration(hintText: '입력하기')),
                    const SizedBox(height: 14),
                    _label('평균 페이스'),
                    TextField(controller: _pace, decoration: const InputDecoration(hintText: '입력하기')),
                    const SizedBox(height: 14),
                    _label('러닝 메모(선택)'),
                    TextField(
                      controller: _note,
                      maxLines: 4,
                      maxLength: 200,
                      buildCounter: (ctx, {required currentLength, required isFocused, maxLength}) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('$currentLength/200',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(label: '기록 저장하기', onPressed: _save),
        ],
      ),
    );
  }

  Widget _label(String l) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(l, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      );
}
