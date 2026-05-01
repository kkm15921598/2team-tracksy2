import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/nav_controller.dart';
import '../state/user_store.dart';
import '../theme/colors.dart';
import '../widgets/app_header.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _y = TextEditingController();
  final _m = TextEditingController();
  final _d = TextEditingController();
  String _style = '산책/러닝';

  @override
  void dispose() {
    _name.dispose();
    _y.dispose();
    _m.dispose();
    _d.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      showToast(context, '이름을 입력해주세요');
      return;
    }
    if (_y.text.isEmpty || _m.text.isEmpty || _d.text.isEmpty) {
      showToast(context, '생년월일을 입력해주세요');
      return;
    }
    final user = context.read<UserStore>();
    user.update(
      name: _name.text.trim(),
      birth:
          '${_y.text}.${_m.text.padLeft(2, '0')}.${_d.text.padLeft(2, '0')}',
      style: _style,
    );
    showToast(context, '계정이 만들어졌어요!');
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) context.read<NavController>().resetTo('home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('정보 입력',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text('트랙시에 등록할 내 정보를 입력하세요',
                    style: TextStyle(color: AppColors.textSoft, fontSize: 13)),
                const SizedBox(height: 28),
                _Field(
                  label: '이름',
                  child: TextField(
                    controller: _name,
                    decoration: const InputDecoration(hintText: '이름을 입력하세요'),
                  ),
                ),
                _Field(
                  label: '생년월일',
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _y,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '년*', counterText: ''),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _m,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '월*', counterText: ''),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _d,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: '일*', counterText: ''),
                        ),
                      ),
                    ],
                  ),
                ),
                _Field(
                  label: '선호하는 러닝 스타일',
                  child: Column(
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
                ),
                const SizedBox(height: 12),
                PrimaryButton(label: '계정 만들기', onPressed: _submit),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final Widget child;
  const _Field({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
