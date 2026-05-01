import 'package:flutter/foundation.dart';
import '../models/inquiry.dart';

class InquiryStore extends ChangeNotifier {
  List<Inquiry> items = const [
    Inquiry(
      id: 1,
      type: '서비스 이용',
      title: '기록이 저장되지 않아요.',
      date: '2026.01.01 14:30',
      body: '가민에서 기록 떠서 왔는데, 저장이 안되어 있어서 문의합니다.',
      reply:
          '안녕하세요. 트랙시 고객 센터 입니다.\n\n기록이 저장되지 않는 현상은 앱의 캐시 데이터가 영향을 주는 경우로 아래 방법에 따라 확인 부탁드립니다.',
      status: 'wait',
    ),
    Inquiry(
      id: 2,
      type: '계정/로그인',
      title: '기록이 저장되지 않아요.',
      body: '가민에서 기록 떠서 왔는데, 저장이 안되어 있어서 문의합니다.',
      status: 'wait',
    ),
    Inquiry(
      id: 3,
      type: '기타',
      title: '기록이 저장되지 않아요.',
      body: '가민에서 기록 떠서 왔는데, 저장이 안되어 있어서 문의합니다.',
      status: 'wait',
    ),
    Inquiry(
      id: 4,
      type: '서비스 이용',
      title: '기록이 저장되지 않아요.',
      body: '가민에서 기록 떠서 왔는데, 저장이 안되어 있어서 문의합니다.',
      status: 'done',
    ),
  ];

  Inquiry? byId(int id) {
    for (final i in items) {
      if (i.id == id) return i;
    }
    return null;
  }

  Inquiry add({required String type, required String title, required String body}) {
    final now = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    final date =
        '${now.year}.${two(now.month)}.${two(now.day)} ${two(now.hour)}:${two(now.minute)}';
    final inq = Inquiry(
      id: now.millisecondsSinceEpoch,
      type: type,
      title: title,
      body: body,
      date: date,
      status: 'wait',
    );
    items = [inq, ...items];
    notifyListeners();
    return inq;
  }
}
