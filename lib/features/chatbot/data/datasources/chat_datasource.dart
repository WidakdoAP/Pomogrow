import 'package:dio/dio.dart';
import 'package:pomogrow/core/.secrets/openai_apikey.dart';

class ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> sendMessage(String message) async {
    final response = await dio.post(
      'https://openrouter.ai/api/v1/chat/completions',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${OpenRouterApiKey.API_KEY}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        "model": "openrouter/owl-alpha",
        "messages": [
          {
            "role": "user",
            "content": message,
          }
        ]
      },
    );

    return response.data;
  }
}