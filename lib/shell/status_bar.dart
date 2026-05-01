import 'package:flutter/material.dart';
import '../theme/colors.dart';

class FakeStatusBar extends StatelessWidget {
  final Color foreground;
  const FakeStatusBar({super.key, this.foreground = AppColors.textPrimary});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '9:41',
              style: TextStyle(
                color: foreground,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.signal_cellular_alt, size: 16, color: foreground),
                const SizedBox(width: 6),
                Icon(Icons.wifi, size: 16, color: foreground),
                const SizedBox(width: 6),
                Container(
                  width: 22,
                  height: 11,
                  decoration: BoxDecoration(
                    border: Border.all(color: foreground, width: 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(1.5),
                    child: Container(
                      width: 14,
                      decoration: BoxDecoration(
                        color: foreground,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
