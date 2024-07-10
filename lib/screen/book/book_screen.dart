import 'package:e_book_app/config/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'package:material_dialogs/dialogs.dart';
import '../../blocs/blocs.dart';
import '../../config/theme/theme_provider.dart';
import '../../model/models.dart';
import '../../repository/repository.dart';
import '../../widget/widget.dart';
import 'components/normal_void.dart';

class BookScreen extends StatefulWidget {
  static const String routeName = '/book';

  final Book book;
  final String uId;
  final ChaptersBloc chaptersBloc;

  const BookScreen(
      {super.key,
      required this.book,
      required this.uId,
      required this.chaptersBloc});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  String selectedText = '';
  String selectedTableText = '';
  bool isTickedWhite = true;
  bool isTickedBlack = false;
  var isToolbar = false;
  double fontSize = SharedService.getFont() ?? 16.0;
  String selectedChapterId = 'Chương 1';
  final ScrollController _scrollController = ScrollController();
  var totalChapters = 0;
  num overallPercentage = 0;
  int times = 1;
  String localSelectedTableText = '';
  String localSelectedChapterId = '';
  bool isFirst = true;
  List<Map<String, dynamic>>? chapterListMap;
  num percent = 0.0;
  TextEditingController noteContentController = TextEditingController();
  late HistoryBloc historyBloc;
  final Map<String, dynamic> chapterScrollPositions = {};
  final Map<String, dynamic> chapterScrollPercentages = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    historyBloc = HistoryBloc(HistoryRepository())
      ..add(LoadHistoryByBookId(widget.book.id ?? '', widget.uId));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isTickedWhite =
            Theme.of(context).appBarTheme.backgroundColor == Colors.white;
        isTickedBlack = !isTickedWhite;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    historyBloc.close();
  }

  void _scrollListener() {
    double maxScrollExtent = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    double percentage = (currentScroll / maxScrollExtent);
    if (chapterScrollPositions[localSelectedChapterId] != null) {
      setState(() {
        isToolbar = true;
      });
    }
    if (isFirst) {
      // Lưu vị trí khi người dùng kéo tới
      chapterScrollPositions[localSelectedChapterId] = currentScroll;
      // Lưu phần trăm đã đọc của chương hiện tại
      chapterScrollPercentages[localSelectedChapterId] = percentage;
    } else {
      // Lưu vị trí khi người dùng kéo tới
      chapterScrollPositions[selectedChapterId] = currentScroll;
      // Lưu phần trăm đã đọc của chương hiện tại
      chapterScrollPercentages[selectedChapterId] = percentage;
    }
    // Tính tổng phần trăm đã đọc của tất cả các chương
    overallPercentage =
        percentAllChapters(chapterScrollPercentages, totalChapters);
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<HistoryBloc>(
          create: (BuildContext context) => historyBloc,
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (overallPercentage.isNaN) {
            overallPercentage = 0;
          }
          if (isTickedWhite &&
              Theme.of(context).appBarTheme.backgroundColor != Colors.white) {
            CustomDialog.show(
                context: context,
                title: 'Do you want save this theme change?',
                dialogColor: Colors.black,
                msgColor: Colors.white,
                titleColor: Colors.white,
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                  Navigator.pop(context, true);
                });
            return false;
          } else if (isTickedBlack &&
              Theme.of(context).appBarTheme.backgroundColor != Colors.black) {
            CustomDialog.show(
                context: context,
                title: 'Do you want save this theme change?',
                dialogColor: Colors.white,
                titleColor: Colors.black,
                msgColor: Colors.black,
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                  Navigator.pop(context, true);
                });
            return false;
          }
          historyBloc.add(AddToHistoryEvent(
              uId: widget.uId,
              chapters: widget.book.id ?? '',
              percent: overallPercentage,
              times: times,
              chapterScrollPositions: chapterScrollPositions,
              chapterScrollPercentages: chapterScrollPercentages));
          return true;
        },
        child: BlocProvider.value(
          value: widget.chaptersBloc,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: isTickedBlack ? Colors.black : Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
              actions: [
                chaptersListIcon(context),
                settingIcon(context),
              ],
            ),
            backgroundColor: isTickedBlack ? Colors.black : Colors.white,
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: BlocBuilder<ChaptersBloc, ChaptersState>(
                            builder: (context, state) {
                              if (state is ChaptersLoaded) {
                                final Map<String, dynamic>? chapter;
                                final chapterList = state.chapters.chapterList;
                                // Convert the chapterList to a list of Map<String, dynamic>.
                                chapterListMap =
                                    chapterList?.entries.map((entry) {
                                  return {
                                    'id': entry.key,
                                    'title': entry.value,
                                  };
                                }).toList();
                                // Sắp xếp danh sách theo key (chapter['id'])
                                sortChapterListMap(chapterListMap);
                                chapter = chapterListMap?[0];
                                totalChapters =
                                    state.chapters.chapterList?.length ??
                                        1 * 100;
                                localSelectedTableText = chapter?['title'];
                                localSelectedChapterId = chapter?['id'];
                              }
                              return BlocBuilder<HistoryBloc, HistoryState>(
                                builder: (context, state) {
                                  if (state is HistoryLoadedById) {
                                    final histories = state.histories;
                                    if (histories.isNotEmpty) {
                                      final historyListMap = histories
                                          .map((histories) {
                                            return histories
                                                .chapterScrollPositions!.entries
                                                .map((entry) {
                                              return {
                                                'id': entry.key,
                                                'title': entry.value,
                                              };
                                            }).toList();
                                          })
                                          .expand((element) => element)
                                          .toList();
                                      if (historyListMap.isNotEmpty) {
                                        sortChapterListMap(historyListMap);
                                        final first = historyListMap.last;
                                        localSelectedChapterId = first['id'];
                                        final chapterHistory = chapterListMap?[
                                            numberInString(
                                                    localSelectedChapterId)! -
                                                1];
                                        localSelectedTableText =
                                            chapterHistory?['title'];
                                        if (isFirst && !isToolbar) {
                                          Future.delayed(Duration.zero, () {
                                            _scrollController
                                                .jumpTo(first['title']);
                                          });
                                        }
                                        final percentListMapPosition = histories
                                            .map(
                                                (e) => e.chapterScrollPositions)
                                            .fold<Map<String, dynamic>>({},
                                                (prev, element) {
                                          prev.addAll(element!);
                                          return prev;
                                        });
                                        mergePercentages(percentListMapPosition,
                                            chapterScrollPositions);
                                        final percentListMap = histories
                                            .map((e) =>
                                                e.chapterScrollPercentages)
                                            .fold<Map<String, dynamic>>({},
                                                (prev, element) {
                                          prev.addAll(element!);
                                          return prev;
                                        });
                                        // print('histories: $percentListMap');
                                        Map<String, dynamic>
                                            newChapterScrollPercentages =
                                            mergePercentages(percentListMap,
                                                chapterScrollPercentages);
                                        if (newChapterScrollPercentages
                                            .isNotEmpty) {
                                          overallPercentage =
                                              percentAllChapters(
                                                  newChapterScrollPercentages,
                                                  totalChapters);
                                        }
                                        // else{
                                        //   percentAllChapters(widget.chapterScrollPercentages);
                                        // }
                                      }
                                    } else {
                                      overallPercentage = percentAllChapters(
                                          chapterScrollPercentages,
                                          totalChapters);
                                    }
                                  }
                                  return Column(
                                    children: [
                                      Text(
                                        isFirst
                                            ? localSelectedChapterId
                                            : selectedChapterId,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: isTickedBlack
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: fontSize),
                                      ),
                                      SelectableText(
                                        isFirst
                                            ? localSelectedTableText
                                            : selectedTableText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: isTickedBlack
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: fontSize),
                                        showCursor: true,
                                        contextMenuBuilder:
                                            (context, editableTextState) {
                                          return AdaptiveTextSelectionToolbar(
                                              anchors: editableTextState
                                                  .contextMenuAnchors,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      120,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF8C2EEE),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Row(
                                                    children: [
                                                      TextButton(
                                                        child: const Row(
                                                          children: [
                                                            Text(
                                                              'Copy',
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Icon(Icons.copy,
                                                                color: Colors
                                                                    .white)
                                                          ],
                                                        ),
                                                        onPressed: () {
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text:
                                                                      selectedText));
                                                        },
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text:
                                                                      selectedText));
                                                          _showClipboardDialog(
                                                              context);
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Text('Save',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .white)),
                                                            Icon(
                                                              Icons.save,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          final translator =
                                                              GoogleTranslator();
                                                          translator
                                                              .translate(
                                                                  selectedText,
                                                                  to: 'vi')
                                                              .then((result) => ScaffoldMessenger.of(
                                                                      context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          content:
                                                                              Text(result.toString()))));
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Text('Trans',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .white)),
                                                            Icon(
                                                              Icons.g_translate,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ]);
                                        },
                                        onSelectionChanged: (selection, cause) {
                                          setState(() {
                                            selectedText = isFirst
                                                ? localSelectedTableText
                                                    .substring(selection.start,
                                                        selection.end)
                                                : selectedTableText.substring(
                                                    selection.start,
                                                    selection.end);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconButton settingIcon(BuildContext context) {
    return IconButton(
      onPressed: () {
        Dialogs.bottomMaterialDialog(
            context: context,
            color: isTickedBlack ? Colors.white : Colors.black,
            actions: [
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      _showClipboardDialog(context);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add,
                            color: isTickedBlack ? Colors.black : Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Add Notes',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  isTickedBlack ? Colors.black : Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.color_lens,
                          color: isTickedBlack ? Colors.black : Colors.white),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Backgrounds',
                        style: TextStyle(
                            fontSize: 17,
                            color: isTickedBlack ? Colors.black : Colors.white),
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
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.black)),
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
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              border: Border.all(color: Colors.white)),
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
                  TextButton(
                    onPressed: () {
                      increaseFontSize();
                      SharedService.setFont(fontSize);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.zoom_in,
                            color: isTickedBlack ? Colors.black : Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Zoom In',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  isTickedBlack ? Colors.black : Colors.white),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      decreaseFontSize();
                      SharedService.setFont(fontSize);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.zoom_out,
                            color: isTickedBlack ? Colors.black : Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Zoom Out',
                          style: TextStyle(
                              fontSize: 17,
                              color:
                                  isTickedBlack ? Colors.black : Colors.white),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(
                            color: isTickedBlack ? Colors.black : Colors.white),
                      ))
                ],
              ),
            ]);
      },
      icon: const Icon(Icons.settings),
    );
  }

  IconButton chaptersListIcon(BuildContext context) {
    return IconButton(
      onPressed: () {
        Dialogs.bottomMaterialDialog(
          context: context,
          color: isTickedBlack ? Colors.white : Colors.black,
          actions: [
            Builder(
              builder: (dialogContext) {
                return BlocProvider.value(
                  value: widget.chaptersBloc,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Chapter',
                          style: TextStyle(
                              color:
                                  isTickedBlack ? Colors.black : Colors.white,
                              fontSize: 20)),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: chapterListMap?.length,
                          itemBuilder: (context, index) {
                            final chapter = chapterListMap![index];
                            // Display the chapter.
                            return ListTile(
                                title: TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                (chapter['id'] == selectedChapterId ||
                                        (isFirst &&
                                            (chapter['id'] ==
                                                localSelectedChapterId)))
                                    ? const Color(0xFFD9D9D9)
                                    : Colors.transparent,
                              )),
                              onPressed: () {
                                Future.delayed(Duration.zero, () {
                                  _scrollController.jumpTo(0.0);
                                });
                                if (_scrollController
                                        .position.maxScrollExtent ==
                                    0.0) {
                                  setState(() {
                                    chapterScrollPercentages[isFirst
                                        ? localSelectedChapterId
                                        : selectedChapterId] = 1;
                                  });
                                }
                                if (chapter['id'] != selectedChapterId) {
                                  if ((isFirst &&
                                          compareChapterId(
                                              localSelectedChapterId,
                                              chapter['id'])) ||
                                      compareChapterId(
                                          selectedChapterId, chapter['id'])) {
                                    CustomDialog.show(
                                      context: context,
                                      title: 'Are you sure back older chapter?',
                                      dialogColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      msgColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      titleColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      onPressed: () {
                                        setState(() {
                                          for (var i =
                                                  chapterListMap?.length ?? 0;
                                              i > 0;
                                              i--) {
                                            if (chapterListMap?[i - 1] !=
                                                null) {
                                              var chapterItem =
                                                  chapterListMap?[i - 1];
                                              if (chapterItem?['id'] !=
                                                  chapter['id']) {
                                                // Xóa item trong chapterScrollPercentages có key bằng chapterItem?['id']
                                                chapterScrollPercentages
                                                    .remove(chapterItem?['id']);
                                                chapterScrollPositions
                                                    .remove(chapterItem?['id']);
                                              } else {
                                                // Nếu chapterItem?['id'] == chapter['id'], ngừng xóa và thoát vòng lặp
                                                break;
                                              }
                                            }
                                            //print(chapterListMap?[i - 1]);
                                          }
                                          historyBloc.add(RemoveItemInHistory(
                                            history: History(
                                              uId: widget.uId,
                                              chapters: widget.book.id ?? '',
                                              percent: overallPercentage,
                                              times: times,
                                              chapterScrollPositions:
                                                  chapterScrollPositions,
                                              chapterScrollPercentages:
                                                  chapterScrollPercentages,
                                            ),
                                          ));
                                        });
                                        Navigator.pop(context);
                                      },
                                      isCancel: true,
                                    ).then((value) {
                                      setState(() {
                                        isFirst = false;
                                        selectedTableText = chapter['title'];
                                        selectedChapterId = chapter['id'];
                                        Navigator.pop(context);
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      isFirst = false;
                                      selectedTableText = chapter['title'];
                                      selectedChapterId = chapter['id'];
                                      Navigator.pop(context);
                                    });
                                  }
                                }
                              },
                              child: Text(
                                chapter['id'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isTickedBlack
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ));
                          },
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color:
                                  isTickedBlack ? Colors.black : Colors.white,
                            ),
                          ))
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
      icon: const Icon(Icons.menu, color: Color(0xFFDFE2E0)),
    );
  }

  void _showClipboardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isTickedBlack ? Colors.white : Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit,
                  color: isTickedBlack ? Colors.black : Colors.white),
              Text(
                'Add Notes',
                style: TextStyle(
                    color: isTickedBlack ? Colors.black : Colors.white),
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                  color: isTickedBlack ? Colors.black : Colors.white,
                  height: 10),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Name:',
                    style: TextStyle(
                        color: isTickedBlack ? Colors.black : Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                            controller: noteContentController,
                            style: TextStyle(
                                color: isTickedBlack
                                    ? Colors.black
                                    : Colors.white),
                            cursorColor:
                                isTickedBlack ? Colors.black : Colors.white,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: isTickedBlack
                                        ? Colors.black
                                        : Colors.white,
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
                    style: TextStyle(
                        color: isTickedBlack ? Colors.black : Colors.white),
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
                                        color: isTickedBlack
                                            ? Colors.black
                                            : Colors.white,
                                        width: 2)),
                                child: Text(
                                  selectedText,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: isTickedBlack
                                          ? Colors.black
                                          : Colors.white),
                                ))
                            : TextFormField(
                                style: TextStyle(
                                    color: isTickedBlack
                                        ? Colors.black
                                        : Colors.white),
                                cursorColor:
                                    isTickedBlack ? Colors.black : Colors.white,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isTickedBlack
                                            ? Colors.black
                                            : Colors.white,
                                        width:
                                            2), // Màu gạch dưới khi TextFormField được focus
                                  ),
                                  enabledBorder: const OutlineInputBorder(
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
                context.read<NoteBloc>().add(AddNewNoteEvent(
                    bookId: widget.book.id ?? '',
                    content: selectedText,
                    title: noteContentController.text,
                    userId: widget.uId));
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
