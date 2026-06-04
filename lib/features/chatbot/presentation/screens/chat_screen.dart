import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/features/chatbot/presentation/providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: AppPalette.gradient3,
      body: Column(
        children: [
          SafeArea(
            top: true,
            left: true,
            child: BackButtonWidgets(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? AppPalette.backgroundColor
                          : AppPalette.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!msg.isUser && msg.model != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.smart_toy,
                                size: 14,
                                color: AppPalette.backgroundColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                msg.model!.split('/').last,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppPalette.backgroundColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                      Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser
                              ? AppPalette.textTitleColor
                              : AppPalette.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                    const InputDecoration(
                      hintText: 'Ask something...',
                      fillColor: AppPalette.backgroundColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final text = controller.text;

                    controller.clear();

                    await ref
                        .read(chatProvider.notifier)
                        .send(text);
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}