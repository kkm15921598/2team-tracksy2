import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/inquiry.dart';
import '../state/inquiry_store.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';

class InquiryListScreen extends StatelessWidget {
  const InquiryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<InquiryStore>().items;
    return Column(
      children: [
        const AppHeader(title: '나의 문의내역'),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _Card(inq: items[i]),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Inquiry inq;
  const _Card({required this.inq});

  Color _typeColor() {
    switch (inq.type) {
      case '서비스 이용':
        return AppColors.primarySoft;
      case '계정/로그인':
        return const Color(0xFFFFEDD5);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _typeFg() {
    switch (inq.type) {
      case '서비스 이용':
        return AppColors.primaryDark;
      case '계정/로그인':
        return const Color(0xFFC2410C);
      default:
        return AppColors.textSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final done = inq.status == 'done';
    return InkWell(
      onTap: () => context.read<NavController>().go('inquiryDetail:${inq.id}'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _tag(inq.type, _typeColor(), _typeFg()),
                const SizedBox(width: 6),
                _tag(
                  done ? '답변 완료' : '답변 대기',
                  done ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                  done ? const Color(0xFF065F46) : const Color(0xFF92400E),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(inq.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text(
              inq.body,
              style: const TextStyle(color: AppColors.textSoft, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String t, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(t, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
