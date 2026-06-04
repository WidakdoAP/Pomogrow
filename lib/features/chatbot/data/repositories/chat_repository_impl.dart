import 'package:pomogrow/features/chatbot/data/datasources/chat_datasource.dart';
import 'package:pomogrow/features/chatbot/data/models/chat_message_model.dart';
import 'package:pomogrow/features/chatbot/domain/entities/chat_message.dart';
import 'package:pomogrow/features/chatbot/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<ChatMessage> sendMessage(String message) async {
    final result = await remoteDataSource.sendMessage(message);

    return ChatMessageModel.fromOpenAI(result);
  }
}