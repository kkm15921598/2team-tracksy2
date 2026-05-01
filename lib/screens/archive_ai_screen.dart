import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/ai_store.dart';
import '../state/nav_controller.dart';
import '../theme/colors.dart';
import '../widgets/mascot.dart';
import '../widgets/primary_button.dart';
import '../widgets/toast.dart';

class ArchiveAiScreen extends StatelessWidget {
  const ArchiveAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ai = context.watch<AiStore>();
    return Stack(
      children: [
        // Header with close
        Column(
          children: [
            _AiHeader(),
            Expanded(
              child: _bodyForStep(context, ai.step),
            ),
          ],
        ),
      ],
    );
  }

  Widget _bodyForStep(BuildContext context, String step) {
    switch (step) {
      case 'chat':
        return const _ChatBody();
      case 'loading':
        return const _LoadingBody();
      case 'result':
        return const _ResultBody();
      case 'skip':
        return const _SkipBody();
      default:
        return const _IntroBody();
    }
  }
}

class _AiHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
      child: Row(
        children: [
          const Expanded(
            child: Text('AI 오늘의 러닝일지',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<AiStore>().reset();
              context.read<NavController>().back();
            },
          ),
        ],
      ),
    );
  }
}

class _IntroBody extends StatelessWidget {
  const _IntroBody();
  @override
  Widget build(BuildContext context) {
    final ai = context.read<AiStore>();
    return Stack(
      children: [
        const _BgChatPreview(blurred: false),
        Positioned.fill(
          child: ColoredBox(color: Colors.black.withOpacity(0.3)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _Sheet(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('AI 오늘의 러닝일지',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text('간단한 대화로 오늘의 러닝을 한 줄로 정리해드려요.',
                    style: TextStyle(color: AppColors.textSoft, fontSize: 13)),
                const SizedBox(height: 14),
                _bullet('💬', '오늘의 기록을 더 간단하게 정리해보세요.'),
                _bullet('❓', '몇 가지 질문에 답하면 충분해요.'),
                const SizedBox(height: 16),
                PrimaryButton(label: '대화 시작 하기', onPressed: () => ai.setStep('chat')),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ai.setStep('skip'),
                  child: const Text('건너뛰기', style: TextStyle(color: AppColors.textSoft)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bullet(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _ChatBody extends StatefulWidget {
  const _ChatBody();
  @override
  State<_ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<_ChatBody> {
  final _scroll = ScrollController();
  final _input = TextEditingController();

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    final ai = context.read<AiStore>();
    ai.addMessage(AiMessage('user', text.trim()));
    _input.clear();
    ai.setSummary('오늘은 안정적인 페이스로\n기분 좋게 달린 날 🏃💜');
    ai.setStep('loading');
    Timer(const Duration(milliseconds: 1400), () {
      if (mounted && context.read<AiStore>().step == 'loading') {
        context.read<AiStore>().setStep('result');
      }
    });
  }

  void _sendMood(String mood) {
    final label = {'good': '좋아', 'ok': '그냥그래', 'bad': '힘들었어'}[mood] ?? '좋아';
    final summary = {
      'good': '오늘은 안정적인 페이스로\n기분 좋게 달린 날 🏃💜',
      'ok': '꾸준함이 가장 큰 힘이에요\n오늘도 잘 달렸어요 💪',
      'bad': '오늘 견뎌낸 한 걸음이\n내일의 나를 만들어요 ✨',
    }[mood]!;
    final ai = context.read<AiStore>();
    ai.addMessage(AiMessage('user', label));
    ai.setSummary(summary);
    ai.setStep('loading');
    Timer(const Duration(milliseconds: 1400), () {
      if (mounted && context.read<AiStore>().step == 'loading') {
        context.read<AiStore>().setStep('result');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ai = context.watch<AiStore>();
    _scrollToBottom();
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              for (final m in ai.messages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _Bubble(from: m.from, text: m.text),
                ),
              const _TypingBubble(),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _quick('😊', '좋아', () => _sendMood('good')),
                  _quick('😐', '그냥그래', () => _sendMood('ok')),
                  _quick('😣', '힘들었어', () => _sendMood('bad')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: const InputDecoration(hintText: '직접 입력하기'),
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _send(_input.text),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _quick(String emoji, String label, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji),
                const SizedBox(width: 4),
                Text(label,
                    style: const TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String from;
  final String text;
  const _Bubble({required this.from, required this.text});
  @override
  Widget build(BuildContext context) {
    final isUser = from == 'user';
    final bubble = Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isUser ? null : Border.all(color: AppColors.border),
      ),
      child: Text(text, style: TextStyle(color: isUser ? Colors.white : AppColors.textPrimary, fontSize: 13)),
    );

    if (isUser) {
      return Align(alignment: Alignment.centerRight, child: bubble);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Mascot(size: 28),
        const SizedBox(width: 6),
        bubble,
      ],
    );
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (ctx, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final t = ((_ctrl.value + i / 3) % 1);
                final scale = 0.6 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Container(
                    width: 6 * scale,
                    height: 6 * scale,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _BgChatPreview(blurred: true),
        Positioned.fill(
          child: ColoredBox(color: Colors.black.withOpacity(0.3)),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Mascot(size: 70),
                ),
                const SizedBox(height: 16),
                const Text('오늘의 러닝을 요약중이에요',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                const _LoadingDots(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final t = ((_ctrl.value + i / 3) % 1);
            final scale = 0.6 + 0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                width: 9 * scale,
                height: 9 * scale,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ResultBody extends StatelessWidget {
  const _ResultBody();
  @override
  Widget build(BuildContext context) {
    final ai = context.watch<AiStore>();
    final summary = ai.summary ?? '오늘은 안정적인 페이스로\n기분 좋게 달린 날 🏃💜';
    return Stack(
      children: [
        const _BgChatPreview(blurred: true),
        Positioned.fill(
          child: ColoredBox(color: Colors.black.withOpacity(0.3)),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('✨ 오늘의 러닝 한 줄 요약 ✨',
                        style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          const Text('"', style: TextStyle(fontSize: 32, color: AppColors.primary, height: 0.5)),
                          Text(
                            summary,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 1.6),
                          ),
                          const Text('"', style: TextStyle(fontSize: 32, color: AppColors.primary, height: 0.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Mascot(size: 50),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text('오늘도 수고했어! 😊',
                              style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                label: '러닝 일지 저장하기',
                onPressed: () {
                  showToast(context, '러닝 일지가 저장되었어요');
                  context.read<AiStore>().reset();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) context.read<NavController>().back();
                  });
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.read<AiStore>().retry(),
                child: const Text('다시하기',
                    style: TextStyle(color: AppColors.textSoft, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkipBody extends StatelessWidget {
  const _SkipBody();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _BgChatPreview(blurred: true),
        Positioned.fill(
          child: ColoredBox(color: Colors.black.withOpacity(0.3)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _Sheet(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('기록 없이 넘어갈까요?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text(
                  '간단한 대화를 통해 오늘을 기록할 수 있어요!\n기록하지 않으면 스튜디오로 바로 들어가져요.',
                  style: TextStyle(color: AppColors.textSoft, fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: '스튜디오 바로가기',
                  onPressed: () {
                    context.read<AiStore>().setStep('intro');
                    context.read<NavController>().resetTo('studio');
                  },
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => context.read<AiStore>().setStep('chat'),
                    child: const Text('대화 시작하기',
                        style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BgChatPreview extends StatelessWidget {
  final bool blurred;
  const _BgChatPreview({required this.blurred});
  @override
  Widget build(BuildContext context) {
    final ai = context.watch<AiStore>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Opacity(
        opacity: blurred ? 0.4 : 1,
        child: ListView(
          children: [
            for (final m in ai.messages)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _Bubble(from: m.from, text: m.text),
              ),
          ],
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  final Widget child;
  const _Sheet({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: child,
    );
  }
}
