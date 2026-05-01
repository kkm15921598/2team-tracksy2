import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../state/user_store.dart';
import '../theme/colors.dart';
import '../widgets/mascot.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';

class CommunityComposeScreen extends StatelessWidget {
  const CommunityComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserStore>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => context.read<NavController>().back(),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFA78BFA), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(user.name, style: const TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(
                onPressed: () => showToast(context, '저장됨'),
                icon: const Icon(Icons.bookmark_border),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
            child: Column(
              children: [
                // Compose canvas
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primarySoft, width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Mascot(size: 80),
                          SizedBox(height: 6),
                          Text('카드 가져오기',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark)),
                        ],
                      ),
                      Positioned(
                        right: 16,
                        bottom: 16,
                        child: GestureDetector(
                          onTap: () => showToast(context, '카드를 가져왔어요'),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const TextField(
                  decoration: InputDecoration(hintText: '캡션 추가...'),
                ),
                const SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(hintText: '해시태그 추가...'),
                ),
                const SizedBox(height: 18),
                PrimaryButton(
                  label: '저장된 템플릿 가져오기',
                  onPressed: () => showToast(context, '저장된 템플릿을 불러왔어요'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
