import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';

import '../../blocs/blocs.dart';
import '../../model/models.dart';

class TextNoteCard extends StatefulWidget {
  final Note note;

  // final double height;

  const TextNoteCard({super.key, required this.note});

  @override
  State<TextNoteCard> createState() => _TextNoteCardState();
}

class _TextNoteCardState extends State<TextNoteCard> {
  TextEditingController titleContentController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Dialogs.bottomMaterialDialog(
            context: context,
            color: const Color(0xFF8C2EEE),
            actions: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                         _showClipboardDialog(context, widget.note);
                        },
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: Colors.white),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Edit',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<NoteBloc>(context).add(
                              RemoveNoteEvent(
                                  bookId: widget.note.bookId,
                                  content: widget.note.content,
                                  title: widget.note.title,
                                  userId: widget.note.uId,
                                  noteId: widget.note.noteId));
                          setState(() {
                            BlocProvider.of<NoteBloc>(context).add(LoadedNote());
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Delete',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ]);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 32, left: 32, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          width: currentWidth,
          // height: height,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.note.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Text(
                  widget.note.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<BookBloc, BookState>(
                        builder: (context, state) {
                          String bookName = widget.note.bookId;
                          if (state is BookLoaded) {
                            Book book = state.books
                                .where((element) => element.id == widget.note.bookId)
                                .first;
                            bookName = book.title;
                          }
                          return Text(
                            bookName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall,
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
      ),
    );
  }
  void _showClipboardDialog(BuildContext context, Note note) {
    contentController.text = note.content;
    titleContentController.text = note.title;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF122158),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.white),
              Text(
                'Edit Notes',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: Colors.white, height: 10),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    'Name:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                            controller: titleContentController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width:
                                    2), // Màu gạch dưới khi TextFormField được focus
                              ),
                              enabledBorder: OutlineInputBorder(
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
                  const Text(
                    'Content:',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                          controller: contentController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white,
                                    width:
                                    2), // Màu gạch dưới khi TextFormField được focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey, width: 2),
                              ),
                            ))
                    )
                    ,
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                BlocProvider.of<NoteBloc>(context).add(
                    EditNoteEvent(
                        bookId: widget.note.bookId,
                        content: widget.note.content,
                        title: widget.note.title,
                        userId: widget.note.uId,
                        noteId: widget.note.noteId));
                setState(() {
                  BlocProvider.of<NoteBloc>(context).add(LoadedNote());
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
