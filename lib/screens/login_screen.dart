import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '로그인',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            '로그인 방법을 선택하세요',
            style: TextStyle(color: AppColors.textSoft, fontSize: 14),
          ),
          const SizedBox(height: 50),
          _SocialBtn(
            label: 'Google 로 계속하기',
            color: Colors.white,
            fg: Colors.black87,
            border: AppColors.border,
            icon: const Icon(Icons.g_mobiledata, color: Color(0xFF4285F4), size: 28),
            onTap: () => context.read<NavController>().go('signup'),
          ),
          _SocialBtn(
            label: '카카오톡으로 계속하기',
            color: AppColors.kakao,
            fg: const Color(0xFF391B1B),
            icon: const Icon(Icons.chat_bubble, color: Color(0xFF391B1B), size: 18),
            onTap: () => context.read<NavController>().go('signup'),
          ),
          _SocialBtn(
            label: '네이버 로 계속하기',
            color: AppColors.naver,
            fg: Colors.white,
            icon: const Text('N', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
            onTap: () => context.read<NavController>().go('signup'),
          ),
          _SocialBtn(
            label: 'Apple 로 계속하기',
            color: Colors.black,
            fg: Colors.white,
            icon: const Icon(Icons.apple, color: Colors.white, size: 20),
            onTap: () => context.read<NavController>().go('signup'),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () => context.read<NavController>().go('home'),
              child: const Text(
                '로그인 없이 둘러보기',
                style: TextStyle(
                  color: AppColors.textSoft,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final Color color;
  final Color fg;
  final Color? border;
  final Widget icon;
  final VoidCallback onTap;
  const _SocialBtn({
    required this.label,
    required this.color,
    required this.fg,
    required this.icon,
    required this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        height: 52,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: fg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: border != null ? BorderSide(color: border!) : BorderSide.none,
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 28, height: 28, child: Center(child: icon)),
              const SizedBox(width: 10),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
