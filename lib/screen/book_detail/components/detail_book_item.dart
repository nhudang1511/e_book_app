import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:readmore/readmore.dart';

import '../../../blocs/blocs.dart';
import '../../../config/shared_preferences.dart';
import '../../../model/book_model.dart';
import '../../../model/models.dart';
import '../../../repository/repository.dart';
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
          })
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
                      Text(widget.book.chapters.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                      const Text('CHAPTERS')
                    ],
                  ),
                  Column(
                    children: [
                      Text(widget.book.country ?? '',
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
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: ElevatedButton(
                              onPressed: () {
                                final Map<String, dynamic> tempPosition = {};
                                final Map<String, dynamic> tempPercent = {};
                                if (widget.book.price == 0 || inHis == true) {
                                  missionUserBloc.add(
                                      EditMissionUsers(mission: missionUser));
                                  Navigator.pushNamed(
                                      context, BookScreen.routeName,
                                      arguments: {
                                        'book': widget.book,
                                        'uId': uId,
                                        'chapterScrollPositions': tempPosition,
                                        'chapterScrollPercentages': tempPercent,
                                      });
                                } else {
                                  if (coins >= widget.book.price!) {
                                    final int newCoins =
                                        coins - widget.book.price!;
                                    coinsBloc.add(EditCoinsEvent(
                                        quantity: newCoins,
                                        uId: SharedService.getUserId() ?? '',
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
                                        });
                                  } else {
                                    Dialogs.materialDialog(
                                        msg:
                                            'Please add coins to read this book',
                                        title: "Warning",
                                        color: Colors.white,
                                        context: context,
                                        actions: [
                                          IconsButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            text: "Ok",
                                            iconData: Icons.cancel,
                                            color: Colors.greenAccent,
                                            textStyle: const TextStyle(
                                                color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ]);
                                  }
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        100), // Adjust the radius as needed
                                  ),
                                ),
                              ),
                              child: const Text('READ',
                                  style: TextStyle(color: Colors.white)),
                            )),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, BookListenScreen.routeName,
                                    arguments: {
                                      'book': widget.book,
                                      'uId': uId,
                                    });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        100), // Adjust the radius as needed
                                  ),
                                ),
                              ),
                              child: const Text('LISTEN',
                                  style: TextStyle(color: Colors.white)),
                            )),
                      ],
                    );
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
                                    100), // Adjust the radius as needed
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
