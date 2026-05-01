import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';

class AppHeader extends StatelessWidget {
  final String? title;
  final Widget? right;
  final Color foreground;
  final bool transparent;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    this.title,
    this.right,
    this.foreground = AppColors.textPrimary,
    this.transparent = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      color: transparent ? Colors.transparent : Colors.transparent,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => context.read<NavController>().back(),
            icon: Icon(Icons.chevron_left, color: foreground, size: 28),
            splashRadius: 22,
          ),
          Expanded(
            child: Center(
              child: Text(
                title ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
            ),
          ),
          SizedBox(width: 48, child: right),
        ],
      ),
    );
  }
}
