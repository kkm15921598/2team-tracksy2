import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/partners.dart';
import '../models/partner.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(title: '파트너 앱'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('APP 연동하기',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                const Text('파트너 앱을 선택하여 기록을 가져오세요.',
                    style: TextStyle(color: AppColors.textSoft, fontSize: 13)),
                const SizedBox(height: 18),
                ...partners.map((p) => _PartnerRow(p: p)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PartnerRow extends StatelessWidget {
  final Partner p;
  const _PartnerRow({required this.p});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.read<NavController>().go('partnerDetail:${p.id}'),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              partnerLogo(p, 44),
              const SizedBox(width: 12),
              Expanded(child: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600))),
              const Icon(Icons.open_in_new, color: AppColors.textMuted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

Widget partnerLogo(Partner p, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: p.logoBg, begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(size / 4),
    ),
    alignment: Alignment.center,
    child: Text(
      p.initial,
      style: TextStyle(
        color: p.logoFg,
        fontWeight: FontWeight.w900,
        fontSize: size * 0.32,
      ),
    ),
  );
}
