import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PlaceholderScreen extends StatelessWidget {
  final String name;
  const PlaceholderScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✨', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('준비 중인 화면이에요.',
              style: TextStyle(color: AppColors.textSoft, fontSize: 13)),
        ],
      ),
    );
  }
}
