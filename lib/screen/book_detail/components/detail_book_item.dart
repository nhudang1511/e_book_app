import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

import '../../../blocs/blocs.dart';
import '../../../config/shared_preferences.dart';
import '../../../model/models.dart';
import '../../../repository/repository.dart';
import '../../../utils/show_snack_bar.dart';
import '../../../widget/widget.dart';
import '../../screen.dart';

class DetailBookItem extends StatefulWidget {
  final Book book;

  const DetailBookItem({super.key, required this.book});

  @override
  State<DetailBookItem> createState() => _DetailBookItemState();
}

class _DetailBookItemState extends State<DetailBookItem> {
  late MissionBloc missionBloc;
  late MissionUserBloc missionUserBloc;
  late BoughtBloc boughtBloc;
  late CoinsBloc coinsBloc;
  int coins = 0;
  bool inHis = false;
  List<Mission> mission = [];
  MissionUser missionUser = MissionUser();
  late AudioBloc audioBloc;
  bool haveAudio = false;
  late ChaptersBloc chaptersBloc;
  bool haveReading = false;

  void _handleActionButtonPressed(String? uId, bool isListen) {
    if (widget.book.price == 0 || inHis == true) {
      missionUserBloc.add(EditMissionUsers(mission: missionUser));
      missionUserBloc.add(LoadedMissionUsers(uId: SharedService.getUserId() ?? ''));
      Navigator.pushNamed(context, isListen ? BookListenScreen.routeName : BookScreen.routeName, arguments: {
        'book': widget.book,
        'uId': uId,
        'bloc': isListen ? audioBloc : chaptersBloc,
      });
    } else {
      if (coins >= widget.book.price!) {
        CustomDialog.show(
          context: context,
          title: 'Are you sure you will buy this book?',
          dialogColor: Theme.of(context).colorScheme.secondaryContainer,
          msgColor: Theme.of(context).colorScheme.background,
          titleColor: Theme.of(context).colorScheme.background,
          onPressed: () {
            Navigator.of(context).pop();
            boughtBloc.add(AddNewBoughtEvent(
              bought: Bought(
                uId: uId,
                status: true,
                coin: widget.book.price,
                createdAt: Timestamp.fromDate(DateTime.now()),
                updateAt: Timestamp.fromDate(DateTime.now()),
                bookId: widget.book.id,
              ),
            ));
            ShowSnackBar.success('Buy books successfully', context);
            Navigator.pushNamed(context, isListen ? BookListenScreen.routeName : BookScreen.routeName, arguments: {
              'book': widget.book,
              'uId': uId,
              'bloc': isListen ? audioBloc : chaptersBloc,
            }).then((value) {
              inHis = true;
              boughtBloc.add(LoadedBought(uId: uId ?? ''));
            });
          },
          isCancel: true,
        );
      } else {
        CustomDialog.show(
          context: context,
          title: 'Please add coins to read this book',
          dialogColor: Theme.of(context).colorScheme.secondaryContainer,
          msgColor: Theme.of(context).colorScheme.background,
          titleColor: Theme.of(context).colorScheme.background,
          onPressed: () {
            Navigator.pop(context, true);
          },
        );
      }
    }
  }


  @override
  void initState() {
    super.initState();
    missionBloc = MissionBloc(MissionRepository())
      ..add(LoadedMissionsByType(type: 'read'));
    missionUserBloc = MissionUserBloc(MissionUserRepository());
    audioBloc = AudioBloc(AudioRepository())
      ..add(LoadAudio(widget.book.id ?? ''));
    chaptersBloc = ChaptersBloc(ChaptersRepository())
      ..add(LoadChapters(widget.book.id ?? ''));
    boughtBloc = BoughtBloc(BoughtRepository())
      ..add(LoadedBought(uId: SharedService.getUserId() ?? ''));
    coinsBloc = CoinsBloc(CoinsRepository())
      ..add(LoadedCoins(uId: SharedService.getUserId() ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => missionBloc,
        ),
        BlocProvider(create: (context) => missionUserBloc),
        BlocProvider(create: (context) => audioBloc),
        BlocProvider(create: (context) => chaptersBloc),
        BlocProvider(create: (context) => boughtBloc),
        BlocProvider(create: (context) => coinsBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<CoinsBloc, CoinsState>(listener: (context, state) {
            if (state is CoinsLoaded) {
              coins = state.coins.quantity ?? 0;
            }
          }),
          BlocListener<BoughtBloc, BoughtState>(listener: (context, state) {
            if (state is BoughtLoaded) {
              if (state.bought.bookId == widget.book.id) {
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
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (haveReading && haveAudio) ...[
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: CustomButton(
                              title: 'READ',
                              icon: Icons.menu_book_outlined,
                              onPressed: () {
                                _handleActionButtonPressed(uId, false);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: CustomButton(
                              title: 'LISTEN',
                              icon: Icons.volume_up,
                              onPressed: () {
                                _handleActionButtonPressed(uId, true);
                              },
                            ),
                          ),
                        ],
                        if (haveReading && !haveAudio)
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: CustomButton(
                              onPressed: () {
                                _handleActionButtonPressed(uId, false);
                              },
                              icon: Icons.menu_book_outlined,
                              title: 'READ',
                            ),
                          ),
                        if (!haveReading && haveAudio)
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: CustomButton(
                              onPressed: () {
                                _handleActionButtonPressed(uId, true);
                              },
                              icon: Icons.volume_up,
                              title: 'LISTEN',
                            ),
                          ),
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
