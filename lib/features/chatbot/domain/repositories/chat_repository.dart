import 'package:pomogrow/features/chatbot/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendMessage(String message);
}