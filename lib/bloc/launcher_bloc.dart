import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:game_launcher_windows/model/game_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

part 'launcher_event.dart';
part 'launcher_state.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  late Box<GameModel> box;

  LauncherBloc() : super(const LauncherState()) {
    _init();
    on<LoadGames>((event, emit) {});

    on<AddGames>((event, emit) async {
      final updatedList = List<GameModel>.from(state.games)
        ..add(event.gameModel);
      await box.add(event.gameModel);
      emit(state.copyWith(games: updatedList));
    });

    on<LaunchGame>((event, emit) async {
      try {
        await Process.run(event.gameModel.path, []);
      } catch (e) {
        debugPrint('failed to run games,Error $e');
      }
    });

    on<DeleteGame>((event, emit) async {
      final updatedList = List<GameModel>.from(state.games)
        ..remove(event.gameModel);
      await event.gameModel.delete();
      emit(state.copyWith(games: updatedList));
    });
  }
  Future<void> _init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GameModelAdapter());
    box = await Hive.openBox<GameModel>('games');

    final games = box.values.toList();
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(games: games));
  }
}
