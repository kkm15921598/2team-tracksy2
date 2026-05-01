import 'package:flutter/foundation.dart';

class CommunityStore extends ChangeNotifier {
  String tab = 'hot'; // hot | new

  void setTab(String t) {
    tab = t;
    notifyListeners();
  }
}
