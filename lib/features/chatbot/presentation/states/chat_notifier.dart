import 'package:flutter_riverpod/legacy.dart';
import 'package:pomogrow/features/chatbot/domain/entities/chat_message.dart';
import 'package:pomogrow/features/chatbot/domain/usecases/send_message.dart';

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final SendMessage sendMessageUseCase;

  ChatNotifier(this.sendMessageUseCase) : super([]);

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text, isUser: true);

    state = [...state, userMessage];

    final response = await sendMessageUseCase(text);

    state = [...state, response];
  }
}