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
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NoteBloc>(context).add(LoadedNote());
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
              if (state is NoteLoaded) {
                var listNotes = state.notes
                    .where((element) => element.uId == widget.user.id)
                    .toList();
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
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
