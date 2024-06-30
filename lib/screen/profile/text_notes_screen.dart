import 'dart:async';
import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/repository/note/note_repository.dart';
import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '../../model/models.dart';

class TextNotesScreen extends StatefulWidget {
  const TextNotesScreen({super.key});

  static const String routeName = '/text_notes';

  @override
  State<TextNotesScreen> createState() => _TextNotesScreenState();
}

class _TextNotesScreenState extends State<TextNotesScreen> {
  String uId = SharedService.getUserId() ?? '';
  List<Note> listNotes = [];
  late NoteBloc noteBloc;
  late Timer _timer;
  TextEditingController titleContentController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    noteBloc = NoteBloc(NoteRepository())..add(LoadedNote(uId: uId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => noteBloc,
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          title: "Text notes",
        ),
        body: Column(
          children: [
            BlocBuilder<NoteBloc, NoteState>(
              builder: (context, state) {
                if (state is NoteLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NoteLoaded) {
                  listNotes = state.notes;
                }
                return Expanded(
                  child: ListView.builder(
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: listNotes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 32, left: 32, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: MediaQuery.of(context).size.width,
                          // height: height,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      listNotes[index].title ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              noteBloc.add(RemoveNoteEvent(
                                                  bookId:
                                                      listNotes[index].bookId ??
                                                          '',
                                                  content: listNotes[index]
                                                          .content ??
                                                      '',
                                                  title:
                                                      listNotes[index].title ??
                                                          '',
                                                  userId:
                                                      listNotes[index].uId ??
                                                          '',
                                                  noteId:
                                                      listNotes[index].noteId ??
                                                          ''));
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  _timer = Timer(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    noteBloc.add(
                                                        LoadedNote(uId: uId));
                                                    Navigator.of(context).pop();
                                                  });
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                },
                                              ).then((value) {
                                                if (_timer.isActive) {
                                                  _timer.cancel();
                                                }
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              _showClipboardDialog(
                                                  context, listNotes[index]);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                  listNotes[index].content ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: BlocBuilder<BookBloc, BookState>(
                                        builder: (context, state) {
                                          String bookName =
                                              listNotes[index].bookId ?? '';
                                          if (state is BookLoaded) {
                                            List<Book> books = state.books;
                                            for(var b in books){
                                              if(b.id == listNotes[index].bookId){
                                                bookName = b.title ?? '';
                                              }
                                            }
                                          }
                                          return Text(
                                            bookName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                            textAlign: TextAlign.end,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClipboardDialog(BuildContext context, Note note) {
    contentController.text = note.content ?? '';
    titleContentController.text = note.title ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Theme.of(context).colorScheme.background),
              Text(
                'Edit Notes',
                style: TextStyle(color: Theme.of(context).colorScheme.background),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: Theme.of(context).colorScheme.background, height: 10),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Name:',
                    style: TextStyle(color: Theme.of(context).colorScheme.background),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                            controller: titleContentController,
                            style: TextStyle(color: Theme.of(context).colorScheme.background),
                            cursorColor: Theme.of(context).colorScheme.background,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.background,
                                    width:
                                        2), // Màu gạch dưới khi TextFormField được focus
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ))),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Content:',
                    style: TextStyle(color: Theme.of(context).colorScheme.background),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                            controller: contentController,
                            style: TextStyle(color: Theme.of(context).colorScheme.background),
                            cursorColor: Theme.of(context).colorScheme.background,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.background,
                                    width:
                                        2), // Màu gạch dưới khi TextFormField được focus
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ))),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                noteBloc.add(EditNoteEvent(
                    bookId: note.bookId ?? '',
                    content: contentController.text.isNotEmpty
                        ? contentController.text
                        : note.content ?? '',
                    title: titleContentController.text.isNotEmpty
                        ? titleContentController.text
                        : note.title ?? '',
                    userId: note.uId ?? '',
                    noteId: note.noteId ?? ''));
                _timer = Timer(const Duration(seconds: 1), () {
                  noteBloc.add(LoadedNote(uId: uId));
                  Navigator.of(context).pop();
                });
              },
              child: Text(
                'Save',
                style: TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ],
        );
      },
    );
  }
}
