import 'package:bloc/bloc.dart';

import 'mission_event.dart';
import 'mission_state.dart';

class MissionBloc extends Bloc<MissionEvent, MissionState> {
  MissionBloc() : super(MissionState().init());

  @override
  Stream<MissionState> mapEventToState(MissionEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    }
  }

  Future<MissionState> init() async {
    return state.clone();
  }
}
