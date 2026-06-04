import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/storage/editor_draft_storage.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/features/notes/presentation/providers/notes_provider.dart';
import 'package:pomogrow/features/notes/presentation/widgets/image_picker.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final String noteId;

  const NoteEditorScreen({
    super.key,
    required this.noteId,
  });

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> saveDraft() async {
    await EditorDraftStorage.saveDraft(
      noteId: widget.noteId,
      title: titleController.text,
      content: contentController.text,
    );
  }

  Future<void> initialize() async {
    final repository = ref.read(noteRepositoryProvider);
    final note = await repository.getNote(widget.noteId);
    final draft = await EditorDraftStorage.loadDraft(widget.noteId);

    if (!mounted) return;

    titleController.text = draft['title']?.isNotEmpty == true
        ? draft['title']!
        : note.title;

    contentController.text = draft['content']?.isNotEmpty == true
        ? draft['content']!
        : note.content;
  }

  @override
  void initState() {
    super.initState();
    initialize();

    Future.microtask(() {
      ref
          .read(noteEditorProvider.notifier)
          .load(widget.noteId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(noteEditorProvider);

    return Scaffold(
      backgroundColor: AppPalette.gradient3,
      appBar: AppBar(
        backgroundColor: AppPalette.transparentColor,
        actions: [
          IconButton(
            onPressed: () async {
              await ref
                  .read(noteEditorProvider.notifier)
                  .save(
                noteId: widget.noteId,
                title: titleController.text,
                content: contentController.text,
              );
              await EditorDraftStorage.clearDraft(widget.noteId);

              ref.invalidate(noteProvider);
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPalette.btnBackground,
        foregroundColor: AppPalette.btnForeground,
        onPressed: () async {
          final path = await ImagePickerUtil.pickImage();

          if (path == null) return;

          ref
              .read(noteEditorProvider.notifier)
              .addSticker(noteId: widget.noteId, path: path);
        },
        child: const Icon(Icons.image),
      ),

      body: GestureDetector(
        onTap: () {
          ref
              .read(noteEditorProvider.notifier)
              .clearSelection();
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  TextField(
                    controller: titleController,
                    decoration:
                    const InputDecoration(
                      hintText: 'Title',
                      fillColor: AppPalette.backgroundColor,
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      controller: contentController,
                      expands: true,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      decoration:
                      const InputDecoration(
                        hintText: 'Write something...',
                        border: InputBorder.none,
                        fillColor: AppPalette.backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ...state.stickers.map(
                  (sticker) {

                return Positioned(
                    left: sticker.x,
                    top: sticker.y,
                    child: GestureDetector(
                      behavior: HitTestBehavior.deferToChild,
                      onTap: () {
                        ref
                            .read(noteEditorProvider.notifier)
                            .selectSticker(sticker.id);
                      },
                      onScaleUpdate: (details) {
                        ref
                            .read(noteEditorProvider.notifier)
                            .updateSticker(
                          id: sticker.id,
                          x: sticker.x + (details.focalPointDelta.dx * 1.5),
                          y: sticker.y + (details.focalPointDelta.dy * 1.5),
                          width: (sticker.width * (1 + ((details.scale - 1) * 0.08)))
                              .clamp(50, 500),
                          height: (sticker.height * (1 + ((details.scale - 1) * 0.08)))
                              .clamp(50, 500),
                          rotation: sticker.rotation + (details.rotation * 0.05),
                        );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: state.selectedStickerId == sticker.id
                                ? BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            )
                                : null,

                            child: Transform.rotate(
                              angle: sticker.rotation,

                              child: sticker.isNetwork
                                  ? Image.network(
                                sticker.imageUrl,
                                width: sticker.width,
                                height: sticker.height,
                              )
                                  : Image.file(
                                File(sticker.imageUrl),
                                width: sticker.width,
                                height: sticker.height,
                              ),
                            ),
                          ),

                          if (state.selectedStickerId == sticker.id)

                            Positioned(
                              top: -12,
                              right: -12,

                              child: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(noteEditorProvider.notifier)
                                      .deleteSticker(sticker.id);
                                },

                                child: Container(
                                  padding: const EdgeInsets.all(4),

                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                );
              },
            ),
          ],
        ),
      )
    );
  }
}