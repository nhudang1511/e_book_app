import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

import '../../../blocs/blocs.dart';
import '../../../config/shared_preferences.dart';
import '../../../model/models.dart';
import '../../../repository/repository.dart';
import '../../../widget/widget.dart';
import '../../screen.dart';

class DetailBookItem extends StatefulWidget {
  final Book book;

  const DetailBookItem({super.key, required this.book});

  @override
  State<DetailBookItem> createState() => _DetailBookItemState();
}

class _DetailBookItemState extends State<DetailBookItem> {
  late CoinsBloc coinsBloc;
  late HistoryBloc historyBloc;
  late MissionBloc missionBloc;
  late MissionUserBloc missionUserBloc;
  String uIdInCoins = '';
  int coins = 0;
  String coinsId = '';
  bool inHis = false;
  List<Mission> mission = [];
  MissionUser missionUser = MissionUser();
  late AudioBloc audioBloc;
  bool haveAudio = false;
  late ChaptersBloc chaptersBloc;
  bool haveReading = false;

  @override
  void initState() {
    super.initState();
    coinsBloc = CoinsBloc(CoinsRepository())
      ..add(LoadedCoins(uId: SharedService.getUserId() ?? ''));
    historyBloc = HistoryBloc(HistoryRepository())
      ..add(LoadedHistoryByUId(
          uId: SharedService.getUserId() ?? '', bookId: widget.book.id ?? ''));
    missionBloc = MissionBloc(MissionRepository())
      ..add(LoadedMissionsByType(type: 'read'));
    missionUserBloc = MissionUserBloc(MissionUserRepository());
    audioBloc = AudioBloc(AudioRepository())
      ..add(LoadAudio(widget.book.id ?? ''));
    chaptersBloc = ChaptersBloc(ChaptersRepository())
      ..add(LoadChapters(widget.book.id ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinsBloc>(
          create: (BuildContext context) => coinsBloc,
        ),
        BlocProvider<HistoryBloc>(
          create: (BuildContext context) => historyBloc,
        ),
        BlocProvider(
          create: (context) => missionBloc,
        ),
        BlocProvider(create: (context) => missionUserBloc),
        BlocProvider(create: (context) => audioBloc),
        BlocProvider(create: (context) => chaptersBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CoinsBloc, CoinsState>(listener: (context, state) {
            if (state is CoinsLoaded) {
              uIdInCoins = state.coins.uId ?? '';
              coins = state.coins.quantity ?? 0;
              coinsId = state.coins.coinsId ?? '';
            }
          }),
          BlocListener<HistoryBloc, HistoryState>(listener: (context, state) {
            if (state is HistoryLoadedByUId) {
              if (state.history.id != null) {
                inHis = true;
              }
            }
            //print(inHis);
          }),
          BlocListener<MissionBloc, MissionState>(
            listener: (context, state) {
              //print('m: $state');
              if (state is MissionLoadedByType) {
                mission = state.mission;
                mission.sort(
                  (a, b) => Comparable.compare(
                      b.times as Comparable, a.times as Comparable),
                );
                for (var m in mission) {
                  //print(m.id);
                  missionUserBloc.add(LoadedMissionsUserById(
                      missionId: m.id ?? '',
                      uId: SharedService.getUserId() ?? ''));
                }
              }
            },
          ),
          BlocListener<MissionUserBloc, MissionUserState>(
              listener: (context, state) {
            //print(state);
            if (state is MissionUserLoaded) {
              missionUser = MissionUser(
                  uId: state.mission.uId,
                  times: state.mission.times! + 1,
                  missionId: state.mission.missionId,
                  status: true,
                  id: state.mission.id);
            } else if (state is MissionUserError) {}
          }),
          BlocListener<AudioBloc, AudioState>(listener: (context, state) {
            if (state is AudioLoaded) {
              setState(() {
                haveAudio = true;
              });
            }
          }),
          BlocListener<ChaptersBloc, ChaptersState>(listener: (context, state) {
            if (state is ChaptersLoaded) {
              setState(() {
                haveReading = true;
              });
            }
          }),
        ],
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(widget.book.language ?? 'Null',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                      const Text('LANGUAGE')
                    ],
                  ),
                  Column(
                    children: [
                      Text(widget.book.country ?? 'Null',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                      const Text('COUNTRY')
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                          widget.book.price.toString() == '0'
                              ? 'FREE'
                              : widget.book.price.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                      const Text('COINS')
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ReadMoreText(
                widget.book.description ?? '',
                trimLength: 300,
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthenticateState) {
                    final uId = state.authUser?.uid;
                    return (haveAudio && haveReading)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: CustomButton(
                                    title: 'READ',
                                    icon: Icons.menu_book_outlined,
                                    onPressed: () {
                                      final Map<String, dynamic> tempPosition =
                                          {};
                                      final Map<String, dynamic> tempPercent =
                                          {};
                                      if (widget.book.price == 0 ||
                                          inHis == true) {
                                        missionUserBloc.add(EditMissionUsers(
                                            mission: missionUser));
                                        missionUserBloc.add(LoadedMissionUsers(
                                            uId: SharedService.getUserId() ??
                                                ''));
                                        Navigator.pushNamed(
                                            context, BookScreen.routeName,
                                            arguments: {
                                              'book': widget.book,
                                              'uId': uId,
                                              'chapterScrollPositions':
                                                  tempPosition,
                                              'chapterScrollPercentages':
                                                  tempPercent,
                                              'bloc': chaptersBloc
                                            });
                                      } else {
                                        if (coins >= widget.book.price!) {
                                          final int newCoins =
                                              coins - widget.book.price!;
                                          coinsBloc.add(EditCoinsEvent(
                                              quantity: newCoins,
                                              uId: SharedService.getUserId() ??
                                                  '',
                                              coinsId: coinsId));
                                          Navigator.pushNamed(
                                              context, BookScreen.routeName,
                                              arguments: {
                                                'book': widget.book,
                                                'uId': uId,
                                                'chapterScrollPositions':
                                                    tempPosition,
                                                'chapterScrollPercentages':
                                                    tempPercent,
                                                'bloc': chaptersBloc
                                              });
                                        } else {
                                          CustomDialog.show(
                                              context: context,
                                              title:
                                                  'Please add coins to read this book',
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
                                                Navigator.pop(context, true);
                                              });
                                        }
                                      }
                                    },
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: CustomButton(
                                    title: 'LISTEN',
                                    icon: Icons.volume_up,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, BookListenScreen.routeName,
                                          arguments: {
                                            'book': widget.book,
                                            'uId': uId,
                                            'bloc': audioBloc
                                          });
                                    },
                                  )),
                            ],
                          )
                        : (haveReading && !haveAudio)
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CustomButton(
                                  onPressed: () {
                                    final Map<String, dynamic> tempPosition =
                                        {};
                                    final Map<String, dynamic> tempPercent = {};
                                    if (widget.book.price == 0 ||
                                        inHis == true) {
                                      missionUserBloc.add(EditMissionUsers(
                                          mission: missionUser));
                                      missionUserBloc.add(LoadedMissionUsers(
                                          uId:
                                              SharedService.getUserId() ?? ''));
                                      Navigator.pushNamed(
                                          context, BookScreen.routeName,
                                          arguments: {
                                            'book': widget.book,
                                            'uId': uId,
                                            'chapterScrollPositions':
                                                tempPosition,
                                            'chapterScrollPercentages':
                                                tempPercent,
                                            'bloc': chaptersBloc
                                          });
                                    } else {
                                      if (coins >= widget.book.price!) {
                                        final int newCoins =
                                            coins - widget.book.price!;
                                        coinsBloc.add(EditCoinsEvent(
                                            quantity: newCoins,
                                            uId:
                                                SharedService.getUserId() ?? '',
                                            coinsId: coinsId));
                                        Navigator.pushNamed(
                                            context, BookScreen.routeName,
                                            arguments: {
                                              'book': widget.book,
                                              'uId': uId,
                                              'chapterScrollPositions':
                                                  tempPosition,
                                              'chapterScrollPercentages':
                                                  tempPercent,
                                              'bloc': chaptersBloc
                                            });
                                      } else {
                                        CustomDialog.show(
                                            context: context,
                                            title:
                                                'Please add coins to read this book',
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
                                              Navigator.pop(context, true);
                                            });
                                      }
                                    }
                                  },
                                  icon: Icons.menu_book_outlined,
                                  title: 'READ',
                                ))
                            : (haveAudio && !haveReading)
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: CustomButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, BookListenScreen.routeName,
                                            arguments: {
                                              'book': widget.book,
                                              'uId': uId,
                                              'bloc': audioBloc
                                            });
                                      },
                                      icon: Icons.volume_up,
                                      title: 'LISTEN',
                                    ))
                                : const SizedBox();
                  } else {
                    return SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    4), // Adjust the radius as needed
                              ),
                            ),
                          ),
                          child: const Text('READ',
                              style: TextStyle(color: Colors.white)),
                        ));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
