import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/inquiry_store.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';

class InquiryDetailScreen extends StatelessWidget {
  final int id;
  const InquiryDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<InquiryStore>();
    final inq = store.byId(id) ?? store.items.first;
    return Column(
      children: [
        const AppHeader(title: '나의 문의내역'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('문의유형', inq.type),
                _row('제목', inq.title),
                _row('문의일시', inq.date ?? '2026.01.01 14:30'),
                const SizedBox(height: 18),
                const Text('문의 내용', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(inq.body, style: const TextStyle(height: 1.6)),
                ),
                if (inq.reply != null) ...[
                  const SizedBox(height: 18),
                  const Text('답변 내용', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(inq.reply!, style: const TextStyle(height: 1.6)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(k, style: const TextStyle(color: AppColors.textSoft, fontSize: 13)),
          ),
          Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
