import 'package:flutter/material.dart';
import 'mascot.dart';

class RunningCard extends StatelessWidget {
  final bool small;
  final List<Color>? bgGradient;
  const RunningCard({super.key, this.small = false, this.bgGradient});

  @override
  Widget build(BuildContext context) {
    final scale = small ? 0.85 : 1.0;
    return AspectRatio(
      aspectRatio: 9 / 14,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgGradient ??
                const [
                  Color(0xFF7DC8E8),
                  Color(0xFFA8D08D),
                  Color(0xFF7BA876),
                ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.45),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32 * scale,
                        height: 32 * scale,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Mascot(size: 28 * scale),
                        ),
                      ),
                      SizedBox(width: 8 * scale),
                      Text('닉네임',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12 * scale,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10 * scale, vertical: 4 * scale),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('오늘도 저님',
                            style: TextStyle(
                                color: Colors.white, fontSize: 10 * scale)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4 * scale),
                  Text('2026.04.06 (월)',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 11 * scale)),
                  SizedBox(height: 18 * scale),
                  Text('이번주 러닝 기록 🏃',
                      style: TextStyle(
                          color: Colors.white, fontSize: 12 * scale)),
                  SizedBox(height: 4 * scale),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 56 * scale,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                      children: [
                        const TextSpan(text: '5.21'),
                        TextSpan(
                            text: ' km',
                            style: TextStyle(
                                fontSize: 18 * scale,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(height: 14 * scale),
                  _stat('⏱', '00:32:45', '운동 시간', scale),
                  _stat('⚡', "6'12\"", '평균 페이스', scale),
                  _stat('🔥', '368', 'kcal', scale),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10 * scale),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            '처음 발걸음이\n큰 변화를 만들어요! 💜',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 11 * scale,
                                height: 1.4),
                          ),
                        ),
                      ),
                      SizedBox(width: 8 * scale),
                      Mascot(size: 56 * scale),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String emoji, String value, String label, double scale) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5 * scale),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 13 * scale)),
          SizedBox(width: 6 * scale),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.w800)),
          SizedBox(width: 6 * scale),
          Text(label,
              style: TextStyle(
                  color: Colors.white70, fontSize: 10 * scale)),
        ],
      ),
    );
  }
}
