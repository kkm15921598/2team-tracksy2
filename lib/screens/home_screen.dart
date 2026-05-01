import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../state/user_store.dart';
import '../theme/colors.dart';
import '../widgets/mascot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        // Center middle slide initially
        final maxOffset = _scrollCtrl.position.maxScrollExtent;
        final minOffset = _scrollCtrl.position.minScrollExtent;
        _scrollCtrl.jumpTo((maxOffset + minOffset) / 2);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserStore>();
    final nav = context.read<NavController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
      child: Column(
        children: [
          // Greeting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Mascot(size: 36),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                          children: [
                            TextSpan(text: user.name),
                            const TextSpan(
                              text: ' 님',
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '오늘도 멋진 러너의 하루를 만들어봐요!',
                        style: TextStyle(color: AppColors.textSoft, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => nav.go('settings'),
                  icon: const Icon(Icons.settings_outlined),
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Hero carousel
          SizedBox(
            height: 220,
            child: ListView(
              controller: _scrollCtrl,
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 60),
              children: [
                _heroSlide(_HeroPhoto()),
                const SizedBox(width: 12),
                _heroSlide(GestureDetector(
                  onTap: () => nav.go('record'),
                  child: const _HeroMain(),
                )),
                const SizedBox(width: 12),
                _heroSlide(_HeroStats()),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Week section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        '이번주 러닝 기록 📅',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          _Legend(label: '기록있음', on: true),
                          SizedBox(width: 8),
                          _Legend(label: '기록없음', on: false),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _DayCell(dow: '일', date: 13, on: false),
                      _DayCell(dow: '월', date: 14, on: true),
                      _DayCell(dow: '화', date: 15, on: true),
                      _DayCell(dow: '수', date: 16, on: false),
                      _DayCell(dow: '목', date: 17, on: true),
                      _DayCell(dow: '금', date: 18, on: false),
                      _DayCell(dow: '토', date: 19, on: false),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _statCard(
                  icon: const Icon(Icons.show_chart, color: AppColors.primary, size: 36),
                  label: '이번달 러닝 횟수',
                  value: '12',
                  unit: '회',
                  badge: '↗ 지난달 대비 20%',
                  badgeColor: const Color(0xFFFCE7F3),
                  badgeFg: const Color(0xFFBE185D),
                )),
                const SizedBox(width: 12),
                Expanded(child: _statCard(
                  icon: const Text('🏆', style: TextStyle(fontSize: 30)),
                  label: '최고 기록(90일간)',
                  value: '10.21',
                  unit: 'km',
                  badge: '2026.04.06 달성!',
                  badgeColor: const Color(0xFFF3F4F6),
                  badgeFg: AppColors.textSoft,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroSlide(Widget child) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 120,
      child: child,
    );
  }

  Widget _statCard({
    required Widget icon,
    required String label,
    required String value,
    required String unit,
    required String badge,
    required Color badgeColor,
    required Color badgeFg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40, child: icon),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSoft)),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge,
              style: TextStyle(fontSize: 11, color: badgeFg, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final String dow;
  final int date;
  final bool on;
  const _DayCell({required this.dow, required this.date, required this.on});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(dow, style: const TextStyle(fontSize: 11, color: AppColors.textSoft)),
        const SizedBox(height: 4),
        Text('$date', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: on ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
            border: on ? null : Border.all(color: AppColors.border, width: 1.4),
          ),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final bool on;
  const _Legend({required this.label, required this.on});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: on ? AppColors.primary : Colors.transparent,
            shape: BoxShape.circle,
            border: on ? null : Border.all(color: AppColors.border, width: 1.2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSoft)),
      ],
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6B7B8C), Color(0xFF334155), Color(0xFF1F2937)],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900),
              children: [
                TextSpan(text: '21'),
                TextSpan(text: ' km', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text('12:45', style: TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}

class _HeroMain extends StatelessWidget {
  const _HeroMain();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Opacity(
              opacity: 0.55,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(120),
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: const Mascot(size: 80),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '러닝 기록하기',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                const Text(
                  '오늘의 러닝을 등록해볼까요?',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('2026.04.06 (월)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              Text('오전 7:30 · 후 18°C',
                  style: TextStyle(fontSize: 11, color: AppColors.textSoft)),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.w900),
              children: [
                TextSpan(text: '5.21'),
                TextSpan(text: ' km', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ..._statRow('⏱', '00:32:45', '시간'),
          ..._statRow('⚡', "6'12\"", '페이스'),
          ..._statRow('🔥', '368', 'kcal'),
        ],
      ),
    );
  }

  List<Widget> _statRow(String emoji, String value, String label) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: AppColors.textSoft, fontSize: 11)),
          ],
        ),
      ),
    ];
  }
}
