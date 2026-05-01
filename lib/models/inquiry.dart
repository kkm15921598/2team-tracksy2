class Inquiry {
  final int id;
  final String type;
  final String title;
  final String body;
  final String? date;
  final String? reply;
  final String status; // 'wait' | 'done'

  const Inquiry({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.date,
    this.reply,
    this.status = 'wait',
  });
}
