import 'package:shared_preferences/shared_preferences.dart';

class EditorDraftStorage {

  static Future<void> saveDraft({
    required String noteId,
    required String title,
    required String content,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('draft_title_$noteId', title);

    await prefs.setString('draft_content_$noteId', content);
  }

  static Future<Map<String, String>> loadDraft(String noteId) async {

    final prefs = await SharedPreferences.getInstance();

    return {
      'title':
      prefs.getString(
        'draft_title_$noteId',
      ) ??
          '',
      'content':
      prefs.getString(
        'draft_content_$noteId',
      ) ??
          '',
    };
  }

  static Future<void> clearDraft(String noteId) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('draft_title_$noteId');

    await prefs.remove('draft_content_$noteId');
  }
}