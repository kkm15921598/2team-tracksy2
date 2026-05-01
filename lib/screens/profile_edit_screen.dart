import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../state/user_store.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});
  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late final TextEditingController _name;
  late final TextEditingController _y;
  late final TextEditingController _m;
  late final TextEditingController _d;
  late final TextEditingController _email;
  late String _style;

  @override
  void initState() {
    super.initState();
    final u = context.read<UserStore>();
    _name = TextEditingController(text: u.name);
    final birthParts = u.birth.split('.');
    _y = TextEditingController(text: birthParts.isNotEmpty ? birthParts[0] : '');
    _m = TextEditingController(text: birthParts.length > 1 ? birthParts[1] : '');
    _d = TextEditingController(text: birthParts.length > 2 ? birthParts[2] : '');
    _email = TextEditingController(text: u.email);
    _style = u.style;
  }

  @override
  void dispose() {
    _name.dispose();
    _y.dispose();
    _m.dispose();
    _d.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      showToast(context, '이름을 입력해주세요');
      return;
    }
    if (_y.text.isEmpty || _m.text.isEmpty || _d.text.isEmpty) {
      showToast(context, '생년월일을 입력해주세요');
      return;
    }
    if (!_email.text.contains('@')) {
      showToast(context, '올바른 이메일을 입력해주세요');
      return;
    }
    context.read<UserStore>().update(
          name: _name.text.trim(),
          birth: '${_y.text}.${_m.text.padLeft(2, '0')}.${_d.text.padLeft(2, '0')}',
          email: _email.text.trim(),
          style: _style,
        );
    showToast(context, '프로필이 수정되었어요');
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) context.read<NavController>().back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(title: '프로필 수정'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, color: AppColors.primary, size: 32),
                  ),
                ),
                const SizedBox(height: 24),
                _label('이름'),
                TextField(controller: _name),
                const SizedBox(height: 16),
                _label('생년월일'),
                Row(
                  children: [
                    Expanded(child: TextField(controller: _y, decoration: const InputDecoration(hintText: '년'))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: _m, decoration: const InputDecoration(hintText: '월'))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: _d, decoration: const InputDecoration(hintText: '일'))),
                  ],
                ),
                const SizedBox(height: 16),
                _label('이메일 계정'),
                TextField(controller: _email),
                const SizedBox(height: 16),
                _label('선호하는 러닝 스타일'),
                Column(
                  children: ['산책/러닝', '10k 미만 러닝', '마라톤'].map((v) {
                    return RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(v, style: const TextStyle(fontSize: 14)),
                      value: v,
                      activeColor: AppColors.primary,
                      groupValue: _style,
                      onChanged: (x) => setState(() => _style = x ?? _style),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                PrimaryButton(label: '저장하기', onPressed: _save),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String l) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(l, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      );
}
