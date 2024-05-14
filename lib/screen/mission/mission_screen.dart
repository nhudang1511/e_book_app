import 'package:e_book_app/blocs/mission/mission_bloc.dart';
import 'package:e_book_app/repository/mission/mission_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/mission_model.dart';
import '../../widget/widget.dart';

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
            title: "List missions",
          ),
          body: BlocBuilder<MissionBloc, MissionState>(
            builder: (context, state) {
              List<Mission> missions = [];
              if(state is MissionLoaded){
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
                          side: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff6ae792),
                          child: Text(index.toString()),
                        ),
                        title: Text(
                          'Title ${missions[index].name}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Content: ${missions[index].detail}',
                                style: const TextStyle(color: Colors.black)),
                            Text('Type: ${missions[index].type}',
                                style: const TextStyle(color: Colors.black)),
                            Text('Coins: ${missions[index].coins}',
                                style: const TextStyle(color: Colors.black)),
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
