import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:pomogrow/features/notes/data/datasources/notes_datasource.dart';
import 'package:pomogrow/features/notes/data/datasources/sticker_datasource.dart';
import 'package:pomogrow/features/notes/data/repositories/note_repo_impl.dart';
import 'package:pomogrow/features/notes/data/repositories/sticker_repo_impl.dart';
import 'package:pomogrow/features/notes/domain/entities/note_entity.dart';
import 'package:pomogrow/features/notes/domain/repositories/note_repository.dart';
import 'package:pomogrow/features/notes/domain/repositories/sticker_repository.dart';
import 'package:pomogrow/features/notes/presentation/controllers/note_editor_controller.dart';
import 'package:pomogrow/features/notes/presentation/states/note_editor_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final noteDatasourceProvider = Provider(
        (ref) => NotesDatasourceImpl(ref.watch(supabaseProvider))
);

final noteRepositoryProvider = Provider(
    (ref) => NoteRepoImpl(ref.watch(noteDatasourceProvider))
);

final stickerDatasourceProvider = Provider<StickerDatasource>(
        (ref) => StickerDatasourceImpl(ref.watch(supabaseProvider))
);

final stickerRepositoryProvider = Provider<StickerRepository>(
        (ref) => StickerRepoImpl(ref.watch(stickerDatasourceProvider))
);

final noteEditorProvider = StateNotifierProvider.autoDispose<
    NoteEditorController, NoteEditorState>((ref) {
  return NoteEditorController(
    ref.watch(stickerRepositoryProvider),
    ref.watch(noteRepositoryProvider),
  );
});

final noteProvider = AsyncNotifierProvider<NotesController, List<NoteEntity>>(
  NotesController.new,
);

class NotesController extends AsyncNotifier<List<NoteEntity>> {
  NotesRepository get repository => ref.read(noteRepositoryProvider);

  @override
  Future<List<NoteEntity>> build() async {
    return repository.getNotes();
  }

  Future<void> createNote() async {
    try {
      await repository.createNote();
      state = const AsyncLoading();

      final notes = await repository.getNotes();
      state = AsyncData(notes);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await repository.deleteNote(id);
      state = const AsyncLoading();

      final notes = await repository.getNotes();
      state = AsyncData(notes);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
