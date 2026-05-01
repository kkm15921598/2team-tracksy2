import 'package:flutter/foundation.dart';

class AiMessage {
  final String from; // 'bot' | 'user'
  final String text;
  const AiMessage(this.from, this.text);
}

class AiStore extends ChangeNotifier {
  String step = 'intro'; // intro | chat | loading | result | skip
  List<AiMessage> messages = const [
    AiMessage('bot', '오늘 5km 뛰었네! 꽤 괜찮은데 ✨'),
    AiMessage('bot', '뛸 때 컨디션은 어땠어?'),
  ];
  String? summary;

  void reset() {
    step = 'intro';
    messages = const [
      AiMessage('bot', '오늘 5km 뛰었네! 꽤 괜찮은데 ✨'),
      AiMessage('bot', '뛸 때 컨디션은 어땠어?'),
    ];
    summary = null;
    notifyListeners();
  }

  void setStep(String s) {
    step = s;
    notifyListeners();
  }

  void addMessage(AiMessage m) {
    messages = [...messages, m];
    notifyListeners();
  }

  void setSummary(String s) {
    summary = s;
    notifyListeners();
  }

  void retry() {
    messages = const [
      AiMessage('bot', '오늘 5km 뛰었네! 꽤 괜찮은데 ✨'),
      AiMessage('bot', '뛸 때 컨디션은 어땠어?'),
    ];
    summary = null;
    step = 'chat';
    notifyListeners();
  }
}
