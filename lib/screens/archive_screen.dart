import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/sample_archive.dart';
import '../data/sample_gallery.dart';
import '../data/sample_style.dart';
import '../models/run_record.dart';
import '../models/style_card.dart';
import '../state/archive_store.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/mascot.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';

String _pad2(int n) => n.toString().padLeft(2, '0');
String _key(int y, int m, int d) => '$y-${_pad2(m)}-${_pad2(d)}';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ArchiveStore>();
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('보관함',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Text('내 기록, 갤러리, 스타일을 한 곳에서 확인하세요.',
                  style: TextStyle(color: AppColors.textSoft, fontSize: 12)),
              const SizedBox(height: 14),
              _MainTabs(store: store),
              const SizedBox(height: 14),
              if (store.mainTab == 'records') _RecordsBody(store: store),
              if (store.mainTab == 'gallery') _GalleryBody(store: store),
              if (store.mainTab == 'style') _StyleBody(store: store),
            ],
          ),
        ),
        if (store.mainTab == 'gallery' && store.gallerySheet != null)
          _GallerySheet(store: store),
      ],
    );
  }
}

class _MainTabs extends StatelessWidget {
  final ArchiveStore store;
  const _MainTabs({required this.store});

  @override
  Widget build(BuildContext context) {
    Widget tab(String key, String label) {
      final active = store.mainTab == key;
      return Expanded(
        child: InkWell(
          onTap: () => store.setMainTab(key),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: active ? AppColors.primary : AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  color: active ? Colors.white : AppColors.textPrimary,
                )),
          ),
        ),
      );
    }
    return Row(
      children: [
        tab('records', '내 기록 보관소'),
        const SizedBox(width: 8),
        tab('gallery', '갤러리 보관소'),
        const SizedBox(width: 8),
        tab('style', '스타일 보관소'),
      ],
    );
  }
}

// ----- Records body -----
class _RecordsBody extends StatelessWidget {
  final ArchiveStore store;
  const _RecordsBody({required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: store.prevMonth,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('${store.year}년 ${store.month}월',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: store.nextMonth,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(store.view == 'list' ? Icons.calendar_month_outlined : Icons.list),
                onPressed: () => store.setView(store.view == 'list' ? 'calendar' : 'list'),
              ),
              if (store.view == 'calendar')
                IconButton(
                  icon: Icon(store.calExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                  onPressed: store.toggleCal,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (store.view == 'calendar') _CalendarBody(store: store) else _ListBody(store: store),
        const SizedBox(height: 18),
        const _ImportSection(),
        const SizedBox(height: 12),
        const _AiCard(),
      ],
    );
  }
}

class _CalendarBody extends StatelessWidget {
  final ArchiveStore store;
  const _CalendarBody({required this.store});

  @override
  Widget build(BuildContext context) {
    final y = store.year, m = store.month;
    final firstDow = DateTime(y, m, 1).weekday % 7; // 0..6 (sun=0)
    final daysInMonth = DateTime(y, m + 1, 0).day;
    final prevDays = DateTime(y, m, 0).day;
    final cells = <_Cell>[];
    for (int i = 0; i < firstDow; i++) {
      final d = prevDays - firstDow + 1 + i;
      final pm = m == 1 ? 12 : m - 1;
      final py = m == 1 ? y - 1 : y;
      cells.add(_Cell(d, _key(py, pm, d), other: true));
    }
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(_Cell(d, _key(y, m, d), other: false));
    }
    while (cells.length % 7 != 0) {
      final d = cells.length - firstDow - daysInMonth + 1;
      final nm = m == 12 ? 1 : m + 1;
      final ny = m == 12 ? y + 1 : y;
      cells.add(_Cell(d, _key(ny, nm, d), other: true));
    }

    var visible = cells;
    if (!store.calExpanded) {
      String? anchor = store.selected;
      if (anchor == null || !cells.any((c) => c.key == anchor)) {
        anchor = _key(y, m, daysInMonth);
      }
      final idx = cells.indexWhere((c) => c.key == anchor);
      final ws = (idx ~/ 7) * 7;
      visible = cells.sublist(ws, (ws + 14).clamp(0, cells.length));
      if (visible.length < 14) {
        visible = cells.sublist((cells.length - 14).clamp(0, cells.length));
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (i) {
              final color = i == 0
                  ? const Color(0xFFEF4444)
                  : i == 6
                      ? const Color(0xFF3B82F6)
                      : AppColors.textSoft;
              return Expanded(
                child: Center(
                  child: Text(koDow[i],
                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.85,
            ),
            itemCount: visible.length,
            itemBuilder: (ctx, i) {
              final c = visible[i];
              final has = archiveRecords.containsKey(c.key);
              final sel = store.selected == c.key;
              final dow = i % 7;
              Color color;
              if (c.other) {
                color = AppColors.textMuted;
              } else if (dow == 0) {
                color = const Color(0xFFEF4444);
              } else if (dow == 6) {
                color = const Color(0xFF3B82F6);
              } else {
                color = AppColors.textPrimary;
              }
              return InkWell(
                onTap: () => store.pickDate(c.key),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${c.d}',
                        style: TextStyle(
                          color: sel ? Colors.white : color,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: has
                              ? (sel ? Colors.white : AppColors.primary)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _SelectedBlock(store: store),
        ],
      ),
    );
  }
}

class _Cell {
  final int d;
  final String key;
  final bool other;
  _Cell(this.d, this.key, {required this.other});
}

class _SelectedBlock extends StatelessWidget {
  final ArchiveStore store;
  const _SelectedBlock({required this.store});

  String _formatKorean(String key) {
    final parts = key.split('-').map(int.parse).toList();
    final dow = DateTime(parts[0], parts[1], parts[2]).weekday % 7;
    return '${parts[0]}년 ${parts[1]}월 ${parts[2]}일 (${koDow[dow]})';
  }

  @override
  Widget build(BuildContext context) {
    final sel = store.selected;
    if (sel == null) {
      return _emptyBlock(context, '아직 선택된 날짜가 없어요', '날짜를 선택하거나\n기록을 추가해보세요');
    }
    final rec = archiveRecords[sel];
    if (rec == null) {
      return _emptyBlock(context, '선택된 날짜에 기록이 없어요', '오늘의 러닝을 기록하고\n나만의 기록을 만들어보세요');
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_formatKorean(sel),
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
          const SizedBox(height: 10),
          IntrinsicHeight(
            child: Row(
              children: [
                _statCol(rec.dist, 'km', '거리'),
                _divider(),
                _statCol(rec.pace, '/km', '페이스'),
                _divider(),
                _statCol(rec.bpm.toString(), 'bpm', '심박수'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCol(String b, String i, String s) {
    return Expanded(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w900, fontSize: 18),
              children: [
                TextSpan(text: b),
                TextSpan(text: ' $i', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(s, style: const TextStyle(color: AppColors.textSoft, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppColors.primaryLight.withOpacity(0.4),
      );

  Widget _emptyBlock(BuildContext context, String title, String sub) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Mascot(size: 60),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(sub,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSoft, fontSize: 12, height: 1.5)),
          const SizedBox(height: 14),
          PrimaryButton(
            label: '기록 추가하기 +',
            fullWidth: false,
            onPressed: () => context.read<NavController>().go('archiveManual'),
          ),
        ],
      ),
    );
  }
}

class _ListBody extends StatelessWidget {
  final ArchiveStore store;
  const _ListBody({required this.store});

  @override
  Widget build(BuildContext context) {
    final y = store.year, m = store.month;
    final daysInMonth = DateTime(y, m + 1, 0).day;
    final all = <_ListItem>[];
    for (int d = daysInMonth; d >= 1; d--) {
      final k = _key(y, m, d);
      all.add(_ListItem(k, archiveRecords[k]));
    }
    final items = all.take(store.listCount).toList();
    final hasMore = all.length > items.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (final it in items) _row(context, it),
          if (hasMore)
            InkWell(
              onTap: store.loadMore,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('더보기 ▾',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, _ListItem it) {
    final expanded = store.listExpanded == it.key;
    final dateLabel = _format(it.key);
    if (!expanded) {
      return InkWell(
        onTap: () => store.toggleListItem(it.key),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 130,
                child: Text(dateLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
              ),
              Expanded(
                child: it.rec != null
                    ? Text(_short(it.rec!),
                        style: const TextStyle(fontSize: 11, color: AppColors.textSoft),
                        overflow: TextOverflow.ellipsis)
                    : const Text('기록없음',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ),
              const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
            ],
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderSoft)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => store.toggleListItem(it.key),
            child: Row(
              children: [
                Expanded(child: Text(dateLabel, style: const TextStyle(fontWeight: FontWeight.w700))),
                const Icon(Icons.keyboard_arrow_up, color: AppColors.textMuted),
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (it.rec == null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Mascot(size: 44),
                  const SizedBox(height: 8),
                  const Text('선택된 날짜에 기록이 없어요', style: TextStyle(fontWeight: FontWeight.w700)),
                  const Text('오늘의 러닝을 기록해보세요',
                      style: TextStyle(color: AppColors.textSoft, fontSize: 12)),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: '기록 추가하기 +',
                    fullWidth: false,
                    onPressed: () => context.read<NavController>().go('archiveManual'),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                _expStat(it.rec!.dist, 'km', '거리'),
                _expStat(it.rec!.pace, '/km', '페이스'),
                _expStat(it.rec!.bpm.toString(), 'bpm', '심박수'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _expStat(String b, String i, String s) {
    return Expanded(
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
              children: [
                TextSpan(text: b),
                TextSpan(text: ' $i', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(s, style: const TextStyle(color: AppColors.textSoft, fontSize: 11)),
        ],
      ),
    );
  }

  String _format(String key) {
    final p = key.split('-').map(int.parse).toList();
    final dow = DateTime(p[0], p[1], p[2]).weekday % 7;
    return '${p[0]}년 ${p[1]}월 ${p[2]}일 (${koDow[dow]})';
  }

  String _short(RunRecord r) {
    return '${r.dist}km · ${r.pace}/km · ${r.bpm}bpm';
  }
}

class _ListItem {
  final String key;
  final RunRecord? rec;
  _ListItem(this.key, this.rec);
}

class _ImportSection extends StatelessWidget {
  const _ImportSection();
  @override
  Widget build(BuildContext context) {
    Widget tile(IconData icon, String label, String route) {
      return Expanded(
        child: InkWell(
          onTap: () => context.read<NavController>().go(route),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Icon(icon, color: AppColors.primary, size: 24),
                const SizedBox(height: 6),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('데이터 가져오기',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Row(
          children: [
            tile(Icons.edit_outlined, '직접 입력하기', 'archiveManual'),
            const SizedBox(width: 8),
            tile(Icons.sync, '타사앱 연동하기', 'archiveSync'),
            const SizedBox(width: 8),
            tile(Icons.image_search, '캡쳐사진 스캔하기', 'archiveScan'),
          ],
        ),
      ],
    );
  }
}

class _AiCard extends StatelessWidget {
  const _AiCard();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<NavController>().go('archiveAI'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: const [
            Mascot(size: 48),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI 오늘의 러닝일지',
                      style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                  SizedBox(height: 2),
                  Text('대화로 러닝 기록을 정리해보세요',
                      style: TextStyle(color: AppColors.textSoft, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.primaryDark),
          ],
        ),
      ),
    );
  }
}

// ----- Gallery body -----
class _GalleryBody extends StatelessWidget {
  final ArchiveStore store;
  const _GalleryBody({required this.store});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _filterPill('${store.galleryYear}년', () => store.openGallerySheet('year')),
            const SizedBox(width: 8),
            _filterPill('${_pad2(store.galleryMonth)}월', () => store.openGallerySheet('month')),
          ],
        ),
        const SizedBox(height: 12),
        for (final c in galleryCards)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GalleryCard(card: c),
          ),
      ],
    );
  }

  Widget _filterPill(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 16),
          ],
        ),
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  final GalleryCardData card;
  const _GalleryCard({required this.card});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showToast(context, card.title),
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 9 / 13,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: card.bg,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(card.date, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Text(card.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.w900, height: 1),
                  children: [
                    TextSpan(text: card.dist),
                    const TextSpan(text: ' 킬로미터', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _stat(card.pace, '평균 페이스'),
                  _stat(card.time, '시간'),
                  _stat(card.elev, '누적 상승'),
                  _stat(card.kcal.toString(), '칼로리'),
                  _stat(card.bpm.toString(), '평균 심박'),
                  _stat(card.cadence.toString(), '케이던스'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('❤ ${card.likes}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 12),
                  Text('💬 ${card.comments}',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String v, String l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(v, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
        Text(l, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}

class _GallerySheet extends StatelessWidget {
  final ArchiveStore store;
  const _GallerySheet({required this.store});

  @override
  Widget build(BuildContext context) {
    final kind = store.gallerySheet;
    final List<int> items;
    final int current;
    final String title;
    if (kind == 'year') {
      items = [2026, 2025, 2024, 2023, 2022];
      current = store.galleryYear;
      title = '연 단위 선택';
    } else {
      items = [7, 6, 5, 4, 3];
      current = store.galleryMonth;
      title = '월 단위 선택';
    }
    return Stack(
      children: [
        GestureDetector(
          onTap: store.closeGallerySheet,
          child: Container(color: Colors.black.withOpacity(0.4)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Text(title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ...items.map((v) {
                  final active = v == current;
                  final label = kind == 'year' ? '$v년' : '${_pad2(v)}월';
                  return InkWell(
                    onTap: () {
                      if (kind == 'year') {
                        store.setGalleryYear(v);
                      } else {
                        store.setGalleryMonth(v);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(label,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                                    color: active ? AppColors.primary : AppColors.textPrimary)),
                          ),
                          if (active) const Icon(Icons.check, color: AppColors.primary),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                PrimaryButton(label: '선택완료', onPressed: store.closeGallerySheet),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ----- Style body -----
class _StyleBody extends StatelessWidget {
  final ArchiveStore store;
  const _StyleBody({required this.store});

  @override
  Widget build(BuildContext context) {
    final cards = store.styleSubTab == 'saved' ? savedStyles : myStyles;
    return Column(
      children: [
        Row(
          children: [
            _SubTab(
              label: '저장한 스타일',
              active: store.styleSubTab == 'saved',
              onTap: () => store.setStyleSubTab('saved'),
            ),
            const SizedBox(width: 8),
            _SubTab(
              label: '내가 만든 스타일',
              active: store.styleSubTab == 'mine',
              onTap: () => store.setStyleSubTab('mine'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (final c in cards)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              children: [
                _StyleCardWidget(card: c),
                const SizedBox(height: 10),
                PrimaryButton(
                  label: '이 스타일 사용하기',
                  outlined: true,
                  onPressed: () => showToast(context, '${c.title} 스타일을 적용했어요'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SubTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SubTab({required this.label, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.white,
            border: Border.all(color: active ? AppColors.primary : AppColors.border),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  color: active ? Colors.white : AppColors.textPrimary)),
        ),
      ),
    );
  }
}

class _StyleCardWidget extends StatelessWidget {
  final StyleCardData card;
  const _StyleCardWidget({required this.card});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 13,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: card.bg,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(card.date, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                Text(card.title,
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text(card.dist,
                    style: TextStyle(color: card.distColor, fontSize: 56, fontWeight: FontWeight.w900, height: 1)),
                Text('킬로미터',
                    style: TextStyle(color: card.distColor, fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 18),
                Row(
                  children: card.stats.take(3).map((s) => _stat(s)).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: card.stats.skip(3).take(3).map((s) => _stat(s)).toList(),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => showToast(context, '저장됨'),
                child: const Icon(Icons.bookmark, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(StyleStat s) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s.value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800)),
          Text(s.label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
