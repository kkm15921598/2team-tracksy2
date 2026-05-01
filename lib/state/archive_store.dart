import 'package:flutter/foundation.dart';

class ArchiveStore extends ChangeNotifier {
  String mainTab = 'records'; // records | gallery | style
  String view = 'calendar'; // calendar | list
  bool calExpanded = false;
  int year = 2026;
  int month = 4;
  String? selected;
  String? listExpanded;
  int listCount = 4;

  int galleryYear = 2024;
  int galleryMonth = 5;
  String? gallerySheet; // null | year | month

  String styleSubTab = 'saved';

  void setMainTab(String tab) {
    mainTab = tab;
    gallerySheet = null;
    notifyListeners();
  }

  void setView(String v) {
    view = v;
    calExpanded = false;
    listExpanded = null;
    notifyListeners();
  }

  void toggleCal() {
    calExpanded = !calExpanded;
    notifyListeners();
  }

  void prevMonth() {
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    selected = null;
    listExpanded = null;
    listCount = 4;
    notifyListeners();
  }

  void nextMonth() {
    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    selected = null;
    listExpanded = null;
    listCount = 4;
    notifyListeners();
  }

  void pickDate(String key) {
    final parts = key.split('-').map(int.parse).toList();
    if (parts[0] != year || parts[1] != month) {
      year = parts[0];
      month = parts[1];
    }
    selected = (selected == key) ? null : key;
    notifyListeners();
  }

  void toggleListItem(String key) {
    listExpanded = (listExpanded == key) ? null : key;
    notifyListeners();
  }

  void loadMore() {
    listCount += 4;
    notifyListeners();
  }

  void setStyleSubTab(String t) {
    styleSubTab = t;
    notifyListeners();
  }

  void openGallerySheet(String kind) {
    gallerySheet = kind;
    notifyListeners();
  }

  void closeGallerySheet() {
    gallerySheet = null;
    notifyListeners();
  }

  void setGalleryYear(int y) {
    galleryYear = y;
    notifyListeners();
  }

  void setGalleryMonth(int m) {
    galleryMonth = m;
    notifyListeners();
  }
}
