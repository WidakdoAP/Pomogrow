import 'package:pomogrow/features/chatbot/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.text,
    required super.isUser,
    required super.model
  });

  factory ChatMessageModel.fromOpenAI(Map<String, dynamic> json) {
    return ChatMessageModel(
      text: json['choices'][0]['message']['content'],
      isUser: false,
      model: json['model'],
    );
  }
}