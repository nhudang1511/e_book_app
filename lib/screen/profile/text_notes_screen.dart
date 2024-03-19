import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/repository/note/note_repository.dart';
import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';

class TextNotesScreen extends StatefulWidget {
  final User user;

  const TextNotesScreen({super.key, required this.user});

  static const String routeName = '/text_notes';

  static Route route({required User user}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => TextNotesScreen(user: user),
    );
  }

  @override
  State<TextNotesScreen> createState() => _TextNotesScreenState();
}

class _TextNotesScreenState extends State<TextNotesScreen> {
  String uId = SharedService.getUserId() ?? '';
  List<Note> listNotes = [];
  NoteBloc noteBloc = NoteBloc(NoteRepository());
  @override
  void initState() {
    super.initState();
    noteBloc.add(LoadedNote(uId: uId ));
  }
  @override
  void dispose() {
    super.dispose();
    noteBloc.close();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        title: "Text notes",
      ),
      body: Column(
        children: [
          BlocBuilder<NoteBloc, NoteState>(
            builder: (context, state) {
              if(state is NoteLoading){
                return const Center(child: CircularProgressIndicator(),);
              }
              else if (state is NoteLoaded) {
                listNotes = state.notes;
              }
              return Expanded(
                child: ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: listNotes.length,
                  itemBuilder: (BuildContext context, int index) {
                    // double noteHeight = 200 ;
                    return TextNoteCard(note: listNotes[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
