import 'package:flutter/material.dart';
import '../data/partners.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';
import 'partners_screen.dart';

class PartnerDetailScreen extends StatelessWidget {
  final String id;
  const PartnerDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final p = partners.firstWhere((x) => x.id == id, orElse: () => partners.first);
    return Column(
      children: [
        AppHeader(title: p.name),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
            child: Column(
              children: [
                Center(child: partnerLogo(p, 96)),
                const SizedBox(height: 24),
                Text('${p.name} 에 연결',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                Text(
                  p.desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSoft, height: 1.6, fontSize: 13),
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  label: 'APP 연결하기',
                  onPressed: () => showToast(context, '연결 요청을 보냈어요'),
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  label: '기록 동기화 및 가져오기',
                  outlined: true,
                  onPressed: () => showToast(context, '동기화를 시작했어요'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
