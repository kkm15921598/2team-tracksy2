import 'package:flutter/foundation.dart';

class UserStore extends ChangeNotifier {
  String name = '김러너';
  String birth = '2000.01.01';
  String email = 'tracksy1@gmail.com';
  String style = '산책/러닝';

  void update({String? name, String? birth, String? email, String? style}) {
    if (name != null) this.name = name;
    if (birth != null) this.birth = birth;
    if (email != null) this.email = email;
    if (style != null) this.style = style;
    notifyListeners();
  }
}
