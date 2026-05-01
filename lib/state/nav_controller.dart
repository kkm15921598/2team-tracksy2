import 'package:flutter/foundation.dart';

class NavController extends ChangeNotifier {
  final List<String> _stack = ['splash'];

  String get top => _stack.isEmpty ? 'splash' : _stack.last;
  List<String> get stack => List.unmodifiable(_stack);
  int get length => _stack.length;

  String baseOf(String route) => route.split(':').first;
  String? argOf(String route) {
    final parts = route.split(':');
    if (parts.length < 2) return null;
    return parts.sublist(1).join(':');
  }

  void go(String route, {bool replace = false}) {
    if (replace && _stack.isNotEmpty) {
      _stack[_stack.length - 1] = route;
    } else {
      _stack.add(route);
    }
    notifyListeners();
  }

  void back() {
    if (_stack.length > 1) {
      _stack.removeLast();
    }
    notifyListeners();
  }

  void resetTo(String route) {
    _stack
      ..clear()
      ..add(route);
    notifyListeners();
  }
}
