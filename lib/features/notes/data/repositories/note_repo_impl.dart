import 'package:pomogrow/features/notes/data/datasources/notes_datasource.dart';
import 'package:pomogrow/features/notes/domain/entities/note_entity.dart';
import 'package:pomogrow/features/notes/domain/repositories/note_repository.dart';

class NoteRepoImpl implements NotesRepository {
  final NotesDatasource datasource;
  NoteRepoImpl(this.datasource);

  @override
  Future<List<NoteEntity>> getNotes() {
    return datasource.getNotes();
  }

  @override
  Future<NoteEntity> getNote(String id) {
    return datasource.getNote(id);
  }

  @override
  Future<NoteEntity> createNote() {
    return datasource.createNote();
  }

  @override
  Future<void> deleteNote(String id) {
    return datasource.deleteNote(id);
  }

  @override
  Future<void> updateNote({
    required String id,
    required String title,
    required String content
  }) {
    return datasource.updateNote(id: id, title: title, content: content);
  }
}