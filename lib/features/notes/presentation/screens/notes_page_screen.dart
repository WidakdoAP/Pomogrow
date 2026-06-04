import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/features/notes/presentation/providers/notes_provider.dart';
import 'package:pomogrow/features/notes/presentation/screens/note_editor_screen.dart';

class NotesPageScreen extends ConsumerWidget {
  const NotesPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(noteProvider);

    return Scaffold(
      backgroundColor: AppPalette.gradient3,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPalette.btnBackground,
        foregroundColor: AppPalette.btnForeground,
        onPressed: () async {
          await ref
              .read(noteProvider.notifier)
              .createNote();
        },
        child: const Icon(Icons.add),
      ),
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
            child: notesAsync.when(
              data: (notes) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: notes.length,
                  itemBuilder: (_, index) {
                    final note = notes[index];

                    return Card(
                      color: AppPalette.btnForeground,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NoteEditorScreen(
                                noteId: note.id,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          note.title.isEmpty
                              ? 'Untitled'
                              : note.title,
                        ),
                        subtitle: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            await ref
                                .read(noteProvider.notifier)
                                .deleteNote(note.id);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    );
                  },
                );
              },

              error: (e, st) {
                return const Center(
                  child: Text('Error'),
                );
                // debugPrint(e.toString());
                // debugPrint(st.toString());
                //
                // return Center(
                //   child: Text(
                //     e.toString(),
                //   ),
                // );
              },

              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}