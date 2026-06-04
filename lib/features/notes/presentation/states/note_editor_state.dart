import 'package:pomogrow/features/notes/domain/entities/sticker_entity.dart';

class NoteEditorState {
  final List<StickerEntity> stickers;
  final List<StickerEntity> deletedStickers;
  final bool isLoading;
  final bool isSaving;
  final String? selectedStickerId;

  const NoteEditorState({
    required this.stickers,
    required this.isLoading,
    required this.isSaving,
    this.selectedStickerId,
    this.deletedStickers = const [],
  });

  factory NoteEditorState.initial() {
    return const NoteEditorState(
      stickers: [],
      isLoading: false,
      isSaving: false,
      selectedStickerId: "",
      deletedStickers: [],
    );
  }

  NoteEditorState copyWith({
    List<StickerEntity>? stickers,
    bool? isLoading,
    bool? isSaving,
    String? selectedStickerId,
    List<StickerEntity>? deletedStickers,
  }) {
    return NoteEditorState(
      stickers: stickers ?? this.stickers,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      selectedStickerId: selectedStickerId ?? this.selectedStickerId,
      deletedStickers: deletedStickers ?? this.deletedStickers,
    );
  }
}