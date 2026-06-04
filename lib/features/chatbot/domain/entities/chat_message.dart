class ChatMessage {
  final String text;
  final bool isUser;
  final String? model;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.model,
  });
}