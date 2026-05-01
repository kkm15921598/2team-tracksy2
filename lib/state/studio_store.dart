import 'package:flutter/foundation.dart';

class StudioStore extends ChangeNotifier {
  String tab = 'edit'; // edit | text | sticker | design
  String bgPickerTab = 'mine'; // mine | ai
  int? bgPickedIndex = 0;

  void setTab(String t) {
    tab = t;
    notifyListeners();
  }

  void setBgTab(String t) {
    bgPickerTab = t;
    notifyListeners();
  }

  void pickBg(int i) {
    bgPickedIndex = i;
    notifyListeners();
  }
}
