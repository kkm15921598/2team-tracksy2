import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

OverlayEntry? _entry;
Timer? _timer;

void showToast(BuildContext context, String message) {
  final overlay = Overlay.of(context, rootOverlay: true);
  _entry?.remove();
  _entry = null;
  _timer?.cancel();

  final entry = OverlayEntry(
    builder: (ctx) => Positioned(
      bottom: 110,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withOpacity(0.92),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  _entry = entry;
  _timer = Timer(const Duration(milliseconds: 1800), () {
    entry.remove();
    if (_entry == entry) _entry = null;
  });
}
