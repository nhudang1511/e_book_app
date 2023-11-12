import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translator/translator.dart';
import 'package:material_dialogs/dialogs.dart';
import '../../blocs/blocs.dart';
import '../../model/models.dart';

class BookScreen extends StatefulWidget {
  static const String routeName = '/book';

  static Route route({required Book book}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => BookScreen(
              book: book,
            ));
  }

  final Book book;

  const BookScreen({super.key, required this.book});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  String selectedText = '';
  String selectedTableText = '';
  OverlayEntry? _overlayEntry;
  bool isTickedWhite = true;
  bool isTickedBlack = false;
  List<String> textSegments = [];
  int currentPage = 0;
  List<TextSpan> highlightedTextSpans = [];
  double fontSize = 16.0;
  bool _isToolbarVisible = false;
  String selectedChapterId = 'Chương 1';


  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChaptersBloc>(context).add(LoadChapters(widget.book.id));

    // Lấy chapter đầu tiên và thiết lập selectedTableText
    BlocProvider.of<ChaptersBloc>(context).stream.listen((state) {
      if (state is ChaptersLoaded && state.chapters.chapterList.isNotEmpty) {
        final firstChapterEntry = state.chapters.chapterList.entries.lastWhere(
          (entry) => entry.key.startsWith('Chương 1'),
        );
        if (mounted) {
          setState(() {
            selectedTableText = firstChapterEntry.value;
            selectedChapterId = firstChapterEntry.key;
          });
        }
      }
    });
  }

  void increaseFontSize() {
    setState(() {
      fontSize += 2.0; // You can adjust the increment as needed
    });
  }

  void decreaseFontSize() {
    setState(() {
      fontSize -= 2.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height * 2;
    splitTextIntoSegments(screenHeight);
    PageController _pageController = PageController(initialPage: currentPage);

    return WillPopScope(
      onWillPop: () async {
        _hideToolbar();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isTickedBlack
              ? Colors.black
              : Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
          actions: [
            IconButton(
              onPressed: () {
                _hideToolbar();
                Dialogs.bottomMaterialDialog(
                    context: context,
                    color: const Color(0xFF122158),
                    actions: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Chapter',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          BlocBuilder<ChaptersBloc, ChaptersState>(
                            builder: (context, state) {
                              if (state is ChaptersLoaded) {
                                final chapterList = state.chapters.chapterList;
                                // Convert the chapterList to a list of Map<String, dynamic>.
                                final chapterListMap =
                                    chapterList.entries.map((entry) {
                                  return {
                                    'id': entry.key,
                                    'title': entry.value,
                                  };
                                }).toList();
                                // Sắp xếp danh sách theo key (chapter['id'])
                                chapterListMap.sort((a, b) {
                                  // Trích xuất số từ chuỗi chương (ví dụ: 'Chương 1' -> 1)
                                  int aNumber = int.parse(a['id']
                                      .replaceAll(RegExp(r'[^0-9]'), ''));
                                  int bNumber = int.parse(b['id']
                                      .replaceAll(RegExp(r'[^0-9]'), ''));
                                  return aNumber.compareTo(bNumber);
                                });
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: chapterListMap.length,
                                    itemBuilder: (context, index) {
                                      final chapter = chapterListMap[index];
                                      // Display the chapter.
                                      return ListTile(
                                          title: TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                          chapter['id'] == selectedChapterId
                                              ? const Color(0xFFD9D9D9)
                                              : Colors.transparent,
                                        )),
                                        onPressed: () {
                                          setState(() {
                                            selectedTableText =
                                                chapter['title'];
                                            selectedChapterId = chapter['id'];
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          chapter['id'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ));
                                    },
                                  ),
                                );
                              } else {
                                return const Text('Something went wrong');
                              }
                            },
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
              icon: const Icon(Icons.menu, color: Color(0xFFDFE2E0)),
            ),
            IconButton(
              onPressed: () {
                _hideToolbar();
                Dialogs.bottomMaterialDialog(
                    context: context,
                    color: const Color(0xFF122158),
                    actions: [
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              _showClipboardDialog(context);
                            },
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: Colors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add Notes',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.color_lens,
                                    color: Colors.white),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Backgrounds',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isTickedWhite = !isTickedWhite;
                                      isTickedBlack = !isTickedBlack;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: isTickedWhite
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.black,
                                            size: 10.0,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isTickedWhite = !isTickedWhite;
                                      isTickedBlack = !isTickedBlack;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: isTickedBlack
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 10.0,
                                          )
                                        : null,
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              increaseFontSize();
                            },
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.zoom_in, color: Colors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Zoom In',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              decreaseFontSize();
                            },
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.zoom_out, color: Colors.white),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Zoom Out',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white),
                                ),
                              ],
                            ),
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
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Page ${currentPage + 1}',
                  style: const TextStyle(fontSize: 18),
            ),
          ],
        )),
        backgroundColor: isTickedBlack ? Colors.black : Colors.white,
        body: Stack(
          children: [
            GestureDetector(
              onTapDown: (details) {
                showToolbar(context, details.localPosition);
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: textSegments.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: SelectableText(
                      textSegments[index],
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: isTickedBlack ? Colors.white : Colors.black,
                          fontSize: fontSize),
                      showCursor: true,
                      toolbarOptions: const ToolbarOptions(
                          selectAll: false, copy: false, cut: true),
                      onSelectionChanged: (selection, cause) {
                        if (selection.start == selection.end) {
                          _hideToolbar();
                        }
                        setState(() {
                          selectedText = textSegments[index]
                              .substring(selection.start, selection.end);
                        });
                      },
                    ),
                  );
                },
                onPageChanged: (int page) {
                  setState(() {
                    currentPage = page;
                  });
                },
              )
              ,
            ),
          ],
        ),
      ),
    );
  }

  void splitTextIntoSegments(double screenHeight) {
    final textLength = selectedTableText.length;
    textSegments.clear();

    if (textLength <= screenHeight) {
      // Nếu đoạn văn bản nhỏ hơn hoặc bằng chiều cao của thiết bị, không cần chia nhỏ
      textSegments.add(selectedTableText);
    } else {
      int start = 0;
      int end = screenHeight.toInt();

      while (end < textLength) {
        while (end < textLength && selectedTableText[end] != ' ') {
          end--;
        }
        textSegments.add(selectedTableText.substring(start, end));
        start = end;
        end += screenHeight.toInt();
      }

      // Thêm phần cuối cùng (nếu còn lại)
      if (start < textLength) {
        textSegments.add(selectedTableText.substring(start));
      }
    }
  }

  void showToolbar(BuildContext context, Offset localPosition) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    if (!_isToolbarVisible) {
      _overlayEntry = OverlayEntry(
        builder: (context) {
          return Positioned(
            right: 30,
            top: localPosition.dy + 30,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF8C2EEE),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  TextButton(
                    child: const Row(
                      children: [
                        Text(
                          'Copy',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        Icon(Icons.copy, color: Colors.white)
                      ],
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: selectedText));
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: selectedText));
                      _showClipboardDialog(context);
                    },
                    child: const Row(
                      children: [
                        Text('Save',
                            style:
                                TextStyle(fontSize: 13, color: Colors.white)),
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final translator = GoogleTranslator();
                      translator.translate(selectedText, to: 'vi').then(
                          (result) => ScaffoldMessenger.of(context)
                              .showSnackBar(
                                  SnackBar(content: Text(result.toString()))));
                    },
                    child: const Row(
                      children: [
                        Text('Trans',
                            style:
                                TextStyle(fontSize: 13, color: Colors.white)),
                        Icon(
                          Icons.g_translate,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _hideToolbar() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isToolbarVisible = false;
    }
  }

  void _showClipboardDialog(BuildContext context) {
    _hideToolbar();
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
                'Add Notes',
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
                        child: selectedText.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                                child: Text(
                                  selectedText,
                                  style: const TextStyle(color: Colors.white),
                                ))
                            : TextFormField(
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
                                ))),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
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
