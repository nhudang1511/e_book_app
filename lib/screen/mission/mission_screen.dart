import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../config/shared_preferences.dart';
import '../../model/mission_model.dart';
import '../../repository/repository.dart';
import '../../widget/widget.dart';
import '../screen.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  static const String routeName = '/mission';

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  late MissionBloc missionBloc;

  @override
  void initState() {
    super.initState();
    missionBloc = MissionBloc(MissionRepository())..add(LoadedMissions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => missionBloc,
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const CustomAppBar(
            title: "Missions",
          ),
          body: BlocBuilder<MissionBloc, MissionState>(
            builder: (context, state) {
              List<Mission> missions = [];
              if (state is MissionLoaded) {
                missions = state.missions;
              }
              return Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: missions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xffafa4f8),
                          child: Text(index.toString(),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .background)),
                        ),
                        title: Text(
                          'Title: ${missions[index].name}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Content: ${missions[index].detail}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer)),
                            Text('Type: ${missions[index].type}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer)),
                            Text('Coins: ${missions[index].coins}',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer)),
                          ],
                        ),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    );
                  },
                ),
              );
            },
          )),
    );
  }
}
