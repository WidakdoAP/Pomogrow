import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pomogrow/features/chatbot/data/datasources/chat_datasource.dart';
import 'package:pomogrow/features/chatbot/data/repositories/chat_repository_impl.dart';
import 'package:pomogrow/features/chatbot/domain/usecases/send_message.dart';
import 'package:pomogrow/features/chatbot/presentation/states/chat_notifier.dart';

final dioProvider = Provider((ref) => Dio());

final remoteDataSourceProvider = Provider((ref) => ChatRemoteDataSource(
    ref.read(dioProvider),
  ),
);

final repositoryProvider = Provider((ref) => ChatRepositoryImpl(
    ref.read(remoteDataSourceProvider),
  ),
);

final sendMessageProvider = Provider((ref) => SendMessage(
    ref.read(repositoryProvider),
  ),
);

final chatProvider = StateNotifierProvider<ChatNotifier, List>(
      (ref) => ChatNotifier(ref.read(sendMessageProvider)),
);