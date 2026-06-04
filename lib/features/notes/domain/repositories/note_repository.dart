import 'package:pomogrow/features/notes/domain/entities/note_entity.dart';

abstract class NotesRepository {
  Future<List<NoteEntity>> getNotes();
  Future<NoteEntity> getNote(String id);

  Future<NoteEntity> createNote();

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
  });

  Future<void> deleteNote(String id);
}