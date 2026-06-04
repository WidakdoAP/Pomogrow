import 'package:pomogrow/features/chatbot/domain/entities/chat_message.dart';
import 'package:pomogrow/features/chatbot/domain/repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<ChatMessage> call(String message) {
    return repository.sendMessage(message);
  }
}