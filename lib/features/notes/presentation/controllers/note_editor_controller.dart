import 'package:flutter_riverpod/legacy.dart';
import 'package:pomogrow/features/notes/domain/entities/sticker_entity.dart';
import 'package:pomogrow/features/notes/domain/repositories/note_repository.dart';
import 'package:pomogrow/features/notes/domain/repositories/sticker_repository.dart';
import 'package:pomogrow/features/notes/presentation/states/note_editor_state.dart';
import 'package:uuid/uuid.dart';

class NoteEditorController
    extends StateNotifier<NoteEditorState> {

  final StickerRepository repository;
  final NotesRepository notesRepository;

  NoteEditorController(
      this.repository,
      this.notesRepository,
      ) : super(
    NoteEditorState.initial(),
  );

  Future<void> load(
      String noteId,
      ) async {

    state = state.copyWith(
      isLoading: true,
    );

    final stickers =
    await repository.getStickers(noteId);

    state = state.copyWith(
      stickers: stickers,
      isLoading: false,
    );
  }

  void addSticker({
    required String noteId,
    required String path,
  }) {
    const uuid = Uuid();
    final sticker = StickerEntity(
      id: uuid.v4(),
      noteId: noteId,
      imageUrl: path,
      isNetwork: false,
      x: 100,
      y: 100,
      width: 120,
      height: 120,
      rotation: 0,
    );

    state = state.copyWith(
      stickers: [
        ...state.stickers,
        sticker,
      ],
    );
  }

  void updateSticker({
    required String id,
    double? x,
    double? y,
    double? width,
    double? height,
    double? rotation,
  }) {

    final updated =
    state.stickers.map((e) {

      if (e.id == id) {

        return e.copyWith(
          x: x ?? e.x,
          y: y ?? e.y,
          width: width ?? e.width,
          height: height ?? e.height,
          rotation: rotation ?? e.rotation,
        );
      }

      return e;

    }).toList();

    state = state.copyWith(
      stickers: updated,
    );
  }

  Future<void> save({
    required String noteId,
    required String title,
    required String content,
  }) async {

    state = state.copyWith(isSaving: true);

    // SAVE NOTE
    await notesRepository.updateNote(
      id: noteId,
      title: title,
      content: content,
    );

    // DELETE REMOVED STICKERS
    for (final sticker in state.deletedStickers) {
      await repository.deleteSticker(sticker);
    }

    // SAVE CURRENT STICKERS
    for (final sticker in state.stickers) {
      await repository.saveSticker(sticker);
    }

    state = state.copyWith(
      isSaving: false,
      deletedStickers: [],
    );
  }

  void selectSticker(String id) {
    if (state.selectedStickerId == id) {
      state = state.copyWith(selectedStickerId: null);
      return;
    }

    state = state.copyWith(selectedStickerId: id);
  }

  void deleteSticker(String id) {
    final sticker = state.stickers.firstWhere((e) => e.id == id);
    final updated = state.stickers.where((e) => e.id != id).toList();

    state = state.copyWith(
      stickers: updated,

      deletedStickers: [
        ...state.deletedStickers,
        sticker,
      ],
      selectedStickerId: null,
    );
  }

  void clearSelection() {
    state = state.copyWith(
      selectedStickerId: null,
    );
  }
}