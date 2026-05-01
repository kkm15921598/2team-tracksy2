import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(title: '기록 추가하기'),
        const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('⏱️', style: TextStyle(fontSize: 56)),
                  SizedBox(height: 12),
                  Text('러닝 기록 추가',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  SizedBox(height: 6),
                  Text(
                    '오늘의 러닝을 직접 기록하거나\n파트너 앱에서 가져오세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSoft, fontSize: 13, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
