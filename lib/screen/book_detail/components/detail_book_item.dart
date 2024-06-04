import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:readmore/readmore.dart';

import '../../../blocs/blocs.dart';
import '../../../config/shared_preferences.dart';
import '../../../model/book_model.dart';
import '../../../repository/repository.dart';
import '../../screen.dart';

class DetailBookItem extends StatefulWidget {
  final Book book;

  const DetailBookItem({super.key, required this.book});

  @override
  State<DetailBookItem> createState() => _DetailBookItemState();
}

class _DetailBookItemState extends State<DetailBookItem> {
  late CoinsBloc _coinsBloc;
  late HistoryBloc _historyBloc;
  String uIdInCoins = '';
  int coins = 0;
  String coinsId = '';
  bool inHis = false;

  @override
  void initState() {
    super.initState();
    _coinsBloc = CoinsBloc(CoinsRepository())
      ..add(LoadedCoins(uId: SharedService.getUserId() ?? ''));
    _historyBloc = HistoryBloc(HistoryRepository())
      ..add(LoadedHistoryByUId(
          uId: SharedService.getUserId() ?? '', bookId: widget.book.id ?? ''));
    // print(widget.book.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CoinsBloc>(
          create: (BuildContext context) => _coinsBloc,
        ),
        BlocProvider<HistoryBloc>(
          create: (BuildContext context) => _historyBloc,
        ),
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
            //print(state);
            if (state is HistoryLoadedByUId) {
              if(state.history.id != null){
                inHis = true;
              }
            }
            //print(inHis);
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
                    return SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        child: ElevatedButton(
                          onPressed: () {
                            final Map<String, dynamic> tempPosition = {};
                            final Map<String, dynamic> tempPercent = {};
                            BlocProvider.of<ChaptersBloc>(context)
                                .add(LoadChapters(widget.book.id ?? ''));
                            if (widget.book.price == 0 || inHis == true) {
                              Navigator.pushNamed(context, BookScreen.routeName,
                                  arguments: {
                                    'book': widget.book,
                                    'uId': uId,
                                    'chapterScrollPositions': tempPosition,
                                    'chapterScrollPercentages': tempPercent,
                                  });
                            }
                            else {
                              if (coins >= widget.book.price!) {
                                final int newCoins = coins - widget.book.price!;
                                _coinsBloc.add(EditCoinsEvent(
                                    quantity: newCoins,
                                    uId: SharedService.getUserId() ?? '',
                                    coinsId: coinsId));
                                Navigator.pushNamed(
                                    context, BookScreen.routeName,
                                    arguments: {
                                      'book': widget.book,
                                      'uId': uId,
                                      'chapterScrollPositions': tempPosition,
                                      'chapterScrollPercentages': tempPercent,
                                    });
                              } else {
                                Dialogs.materialDialog(
                                    msg: 'Please add coins to read this book',
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
                        ));
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
