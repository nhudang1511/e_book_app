import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:e_book_app/repository/history_audio/history_audio_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import '../../blocs/blocs.dart';
import '../../config/theme/theme_provider.dart';
import '../../model/models.dart';
import 'components/normal_void.dart';

class BookListenScreen extends StatefulWidget {
  const BookListenScreen(
      {super.key, required this.book, required this.uId, required this.bloc});

  final Book book;
  final String uId;
  final AudioBloc bloc;

  static const String routeName = '/book_listen';

  @override
  State<BookListenScreen> createState() => _BookListenScreenState();
}

class _BookListenScreenState extends State<BookListenScreen> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Audio audio = Audio();
  var chapterListMap;
  var totalChapters = 0;
  String localSelectedTableText = '';
  String localSelectedChapterId = '';
  String selectedChapterId = 'Chương 1';
  String selectedTableText = '';
  bool isFirst = true;
  bool isTickedWhite = true;
  bool isTickedBlack = false;
  int index = 0;
  num overallPercentage = 0;
  int times = 1;
  var isToolbar = false;
  final Map<String, dynamic> chapterScrollPositions = {};
  final Map<String, dynamic> chapterScrollPercentages = {};

  late StreamSubscription<PlayerState> _playerStateSubscription;
  late StreamSubscription<Duration> _durationSubscription;
  late StreamSubscription<Duration> _positionSubscription;

  late HistoryAudioBloc historyAudioBloc;

  @override
  void initState() {
    super.initState();
    historyAudioBloc = HistoryAudioBloc(HistoryAudioRepository())
      ..add(LoadHistoryAudioByBookId(widget.book.id ?? '', widget.uId));
    _playerStateSubscription = audioPlayer.onPlayerStateChanged.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event == PlayerState.playing;
        });
      }
    });
    _durationSubscription = audioPlayer.onDurationChanged.listen((event) {
      if (mounted) {
        setState(() {
          duration = event;
        });
      }
    });
    _positionSubscription = audioPlayer.onPositionChanged.listen((event) {
      if (mounted) {
        setState(() {
          position = event;
          double percentage = (position.inSeconds / duration.inSeconds);
          if (chapterScrollPositions[localSelectedChapterId] != null) {
            setState(() {
              isToolbar = true;
            });
          }
          if (isFirst) {
            chapterScrollPositions[localSelectedChapterId] = position.inSeconds;
            chapterScrollPercentages[localSelectedChapterId] = percentage;
          } else {
            chapterScrollPositions[selectedChapterId] = position.inSeconds;
            chapterScrollPercentages[selectedChapterId] = percentage;
          }
          overallPercentage = percentAllChapters(chapterScrollPercentages, totalChapters );
        });
      }
    });
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
    _playerStateSubscription.cancel();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hour = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hour, minutes, seconds].join(':');
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
                  value: widget.bloc,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Chapter',
                          style: TextStyle(
                              color:
                                  isTickedBlack ? Colors.black : Colors.white,
                              fontSize: 20)),
                      BlocBuilder<AudioBloc, AudioState>(
                        builder: (context, state) {
                          if (state is AudioLoaded) {
                            final chapterList = state.audio.chapterList;
                            final chapterListMap =
                                chapterList?.entries.map((entry) {
                              return {
                                'id': entry.key,
                                'title': entry.value,
                              };
                            }).toList();
                            chapterListMap?.sort((a, b) {
                              int aNumber = int.parse(
                                  a['id'].replaceAll(RegExp(r'[^0-9]'), ''));
                              int bNumber = int.parse(
                                  b['id'].replaceAll(RegExp(r'[^0-9]'), ''));
                              return aNumber.compareTo(bNumber);
                            });
                            return SizedBox(
                              height:
                                  MediaQuery.of(dialogContext).size.height / 3,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: chapterListMap?.length,
                                itemBuilder: (context, index) {
                                  final chapter = chapterListMap![index];
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
                                      if (chapter['id'] != selectedChapterId) {
                                        setState(() {
                                          isFirst = false;
                                          selectedTableText = chapter['title'];
                                          selectedChapterId = chapter['id'];
                                          Navigator.pop(context);
                                        });
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
                            );
                          } else {
                            return const Text('Something went wrong');
                          }
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HistoryAudioBloc>(
          create: (BuildContext context) => historyAudioBloc,
        ),
      ],
      child: BlocListener<HistoryAudioBloc, HistoryAudioState>(
        listener: (context, state) {
          print(state);
        },
        child: BlocProvider.value(
          value: widget.bloc,
          child: WillPopScope(
            onWillPop: () async {
              if (isTickedWhite &&
                  Theme.of(context).appBarTheme.backgroundColor !=
                      Colors.white) {
                Dialogs.materialDialog(
                    msg: 'Do you want to save theme change?',
                    title: "Warning",
                    color: Colors.black,
                    context: context,
                    actions: [
                      IconsButton(
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                          Navigator.pop(context, true);
                        },
                        text: "Ok",
                        iconData: Icons.cancel,
                        color: Theme.of(context).colorScheme.primary,
                        textStyle: const TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ]);
                return false;
              } else if (isTickedBlack &&
                  Theme.of(context).appBarTheme.backgroundColor !=
                      Colors.black) {
                Dialogs.materialDialog(
                    msg: 'Do you want to save theme change?',
                    title: "Warning",
                    color: Colors.white,
                    context: context,
                    actions: [
                      IconsButton(
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                          Navigator.pop(context, true);
                        },
                        text: "Ok",
                        iconData: Icons.cancel,
                        color: Theme.of(context).colorScheme.primary,
                        textStyle: const TextStyle(color: Colors.white),
                        iconColor: Colors.white,
                      ),
                    ]);
                return false;
              }
              historyAudioBloc.add(AddToHistoryAudioEvent(
                  uId: widget.uId,
                  bookId: widget.book.id ?? '',
                  percent: overallPercentage,
                  times: times,
                  chapterScrollPositions: chapterScrollPositions,
                  chapterScrollPercentages: chapterScrollPercentages));
              return true;
            },
            child: BlocBuilder<AudioBloc, AudioState>(
              builder: (context, state) {
                if (state is AudioLoaded) {
                  final chapter;
                  final chapterList = state.audio.chapterList;
                  chapterListMap = chapterList?.entries.map((entry) {
                    return {
                      'id': entry.key,
                      'title': entry.value,
                    };
                  }).toList();
                  // Sắp xếp danh sách theo key (chapter['id'])
                  chapterListMap.sort((a, b) {
                    // Trích xuất số từ chuỗi chương (ví dụ: 'Chương 1' -> 1)
                    int aNumber =
                        int.parse(a['id'].replaceAll(RegExp(r'[^0-9]'), ''));
                    int bNumber =
                        int.parse(b['id'].replaceAll(RegExp(r'[^0-9]'), ''));
                    return aNumber.compareTo(bNumber);
                  });
                  chapter = chapterListMap[index];
                  totalChapters = state.audio.chapterList?.length ?? 1 * 100;
                  localSelectedTableText = chapter['title'];
                  localSelectedChapterId = chapter['id'];
                }
                return BlocBuilder<HistoryAudioBloc, HistoryAudioState>(
                  builder: (context, state) {
                    if (state is HistoryAudioLoadedById) {
                      final historiesAudio = state.historyAudio;
                      if (historiesAudio.isNotEmpty) {
                        final historyListMap = historiesAudio
                            .map((histories) {
                              return histories.chapterScrollPositions!.entries
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
                          historyListMap.sort((a, b) {
                            int aNumber = int.parse(
                                a['id'].replaceAll(RegExp(r'[^0-9]'), ''));
                            int bNumber = int.parse(
                                b['id'].replaceAll(RegExp(r'[^0-9]'), ''));
                            return aNumber.compareTo(bNumber);
                          });
                          final first = historyListMap.last;
                          localSelectedChapterId = first['id'];
                          final chapterHistory = chapterListMap[
                              numberInString(localSelectedChapterId)! - 1];
                          localSelectedTableText = chapterHistory['title'];
                          if (isFirst && !isToolbar) {
                            audioPlayer
                                .play(UrlSource(localSelectedTableText))
                                .then((value) async {
                              await audioPlayer
                                  .seek(Duration(seconds: first['title']));
                              await audioPlayer.pause();
                            });
                          }
                          final percentListMap = historiesAudio
                              .map((e) => e.chapterScrollPercentages)
                              .fold<Map<String, dynamic>>({}, (prev, element) {
                            prev.addAll(element!);
                            return prev;
                          });
                          Map<String, dynamic> newChapterScrollPercentages =
                              mergePercentages(
                                  percentListMap, chapterScrollPercentages);
                          if (newChapterScrollPercentages.isNotEmpty) {
                            overallPercentage = percentAllChapters(
                                newChapterScrollPercentages, totalChapters);
                          }
                        }
                      } else {
                        overallPercentage = percentAllChapters(
                            chapterScrollPercentages, totalChapters);
                      }
                    }
                    return Scaffold(
                        appBar: AppBar(
                          backgroundColor:
                              isTickedBlack ? Colors.black : Colors.white,
                          elevation: 0,
                          iconTheme:
                              const IconThemeData(color: Color(0xFFDFE2E0)),
                          actions: [
                            chaptersListIcon(context),
                            settingIcon(context),
                          ],
                        ),
                        backgroundColor:
                            isTickedBlack ? Colors.black : Colors.white,
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  widget.book.imageUrl ?? '',
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  height: 350,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.book.title ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: isTickedBlack
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                widget.book.authorName ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: const Color(0xFFC7C7C7),
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              Slider(
                                min: 0,
                                max: duration.inSeconds.toDouble(),
                                value: position.inSeconds.toDouble(),
                                onChanged: (value) async {
                                  final position =
                                      Duration(seconds: value.toInt());
                                  await audioPlayer.seek(position);

                                  await audioPlayer.resume();
                                },
                                thumbColor:
                                    isTickedBlack ? Colors.white : Colors.black,
                                inactiveColor: Colors.grey,
                                activeColor:
                                    isTickedBlack ? Colors.white : Colors.black,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatTime(position),
                                        style: TextStyle(
                                            color: isTickedBlack
                                                ? Colors.white
                                                : Colors.black)),
                                    Text(formatTime(duration),
                                        style: TextStyle(
                                            color: isTickedBlack
                                                ? Colors.white
                                                : Colors.black)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    border: Border.all(
                                        color: isTickedBlack
                                            ? Colors.white
                                            : Colors.black),
                                    color: isTickedBlack
                                        ? Colors.black
                                        : Colors.white),
                                child: Text(
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
                                              : Colors.black),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await audioPlayer.play(UrlSource(isFirst
                                          ? localSelectedTableText
                                          : selectedTableText));
                                      await audioPlayer.seek(Duration(
                                          seconds: position.inSeconds - 10));
                                    },
                                    child: Icon(
                                      Icons.replay_10,
                                      color: isTickedBlack
                                          ? Colors.white
                                          : Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (index > 0 && index < totalChapters) {
                                        setState(() {
                                          index = index - 1;
                                          isFirst = false;
                                          final chapter = chapterListMap[index];
                                          selectedTableText = chapter['title'];
                                          selectedChapterId = chapter['id'];
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.skip_previous_rounded,
                                      color: isTickedBlack
                                          ? Colors.white
                                          : Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: isTickedBlack
                                        ? Colors.white
                                        : Colors.black,
                                    child: IconButton(
                                      icon: Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: isTickedBlack
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                      iconSize: 30,
                                      onPressed: () async {
                                        if (isPlaying) {
                                          await audioPlayer.pause();
                                        } else {
                                          await audioPlayer.play(UrlSource(
                                              isFirst
                                                  ? localSelectedTableText
                                                  : selectedTableText));
                                        }
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (index >= 0 &&
                                          index < totalChapters - 1) {
                                        setState(() {
                                          index = index + 1;
                                          isFirst = false;
                                          final chapter = chapterListMap[index];
                                          selectedTableText = chapter['title'];
                                          selectedChapterId = chapter['id'];
                                        });
                                      }
                                    },
                                    child: Icon(
                                      Icons.skip_next_rounded,
                                      color: isTickedBlack
                                          ? Colors.white
                                          : Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await audioPlayer.play(UrlSource(isFirst
                                          ? localSelectedTableText
                                          : selectedTableText));
                                      await audioPlayer.seek(Duration(
                                          seconds: position.inSeconds + 10));
                                    },
                                    child: Icon(
                                      Icons.forward_10,
                                      color: isTickedBlack
                                          ? Colors.white
                                          : Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ));
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
