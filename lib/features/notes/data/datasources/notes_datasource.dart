import 'package:pomogrow/features/notes/data/models/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NotesDatasource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel> getNote(String id);

  Future<NoteModel> createNote();

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
  });

  Future<void> deleteNote(String id);
}

class NotesDatasourceImpl implements NotesDatasource {
  final SupabaseClient client;

  NotesDatasourceImpl(this.client);

  @override
  Future<List<NoteModel>> getNotes() async {
    final response = await client
        .from('notes')
        .select()
        .order('updated_at', ascending: false);

    return response
        .map<NoteModel>((e) => NoteModel.fromJson(e))
        .toList();
  }

  @override
  Future<NoteModel> getNote(String id) async {

    final response = await client
        .from('notes')
        .select()
        .eq('id', id)
        .single();

    return NoteModel.fromJson(response);
  }

  @override
  Future<NoteModel> createNote() async {
    final user = client.auth.currentUser!;

    final response = await client
        .from('notes')
        .insert({
      'user_id': user.id,
    })
        .select()
        .single();

    return NoteModel.fromJson(response);
  }

  @override
  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    await client
        .from('notes')
        .update({
      'title': title,
      'content': content,
      'updated_at': DateTime.now().toIso8601String(),
    })
        .eq('id', id);
  }

  @override
  Future<void> deleteNote(String id) async {
    await client
        .from('notes')
        .delete()
        .eq('id', id);
  }
}