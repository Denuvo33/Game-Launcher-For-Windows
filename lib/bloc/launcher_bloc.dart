import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:game_launcher_windows/model/game_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'launcher_event.dart';
part 'launcher_state.dart';

class LauncherBloc extends Bloc<LauncherEvent, LauncherState> {
  late Box<GameModel> box;

  LauncherBloc() : super(const LauncherState()) {
    _init();

    on<PickAndAddGame>(_onPickAndAddGame);
    on<PickGamePath>(_pickGamePath);
    on<PickIconPath>(_pickIconPath);
    on<SearchGame>(_searchGame);

    on<SortGame>((event, emit) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('sort', event.sort);
      switch (event.sort) {
        case 'Date Old':
          state.games.sort((a, b) => a.key.compareTo(b.key));
        case 'Date New':
          state.games.sort((a, b) => b.key.compareTo(a.key));
        default:
          state.games.sort((a, b) => a.name!.compareTo(b.name!));
      }
      emit(state.copyWith(sort: event.sort));
    });

    on<AddGames>((event, emit) async {
      final updatedList = List<GameModel>.from(state.games)
        ..add(event.gameModel);
      await box.add(event.gameModel);
      emit(state.copyWith(games: updatedList));
    });

    on<LaunchGame>((event, emit) async {
      try {
        emit(state.copyWith(launchGame: true));
        await Process.run(event.gameModel.path!, []);
        emit(state.copyWith(launchGame: false));
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
  void _searchGame(SearchGame event, Emitter<LauncherState> emit) {
    final games = box.values.toList();
    final searchGames =
        games
            .where(
              (game) => game.name!.toLowerCase().contains(
                event.gameName.toLowerCase(),
              ),
            )
            .toList();
    emit(state.copyWith(games: searchGames));
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GameModelAdapter());
    box = await Hive.openBox<GameModel>('stoka');

    final games = box.values.toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (prefs.getString('sort') ?? 'Date Old') {
      case 'Date Old':
        games.sort((a, b) => a.key.compareTo(b.key));
      case 'Date New':
        games.sort((a, b) => b.key.compareTo(a.key));
      default:
        games.sort((a, b) => a.name!.compareTo(b.name!));
    }
    // ignore: invalid_use_of_visible_for_testing_member
    emit(
      state.copyWith(games: games, sort: prefs.getString('sort') ?? 'Date Old'),
    );
  }

  void _pickGamePath(PickGamePath event, Emitter<LauncherState> emit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['exe'],
    );

    if (result != null && result.files.single.path != null) {
      final gamePath = result.files.single.path!;
      debugPrint('game path $gamePath');
      emit(state.copyWith(tempGamePath: gamePath));
    }
  }

  void _pickIconPath(PickIconPath event, Emitter<LauncherState> emit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ico', 'png', 'jpg', 'jpeg'],
    );
    if (result != null && result.files.single.path != null) {
      final iconPath = result.files.single.path!;
      debugPrint('icon path $iconPath');
      emit(state.copyWith(tempIconPath: iconPath));
    }
  }

  void _onPickAndAddGame(
    PickAndAddGame event,
    Emitter<LauncherState> emit,
  ) async {
    final game = GameModel(
      name: event.gameName,
      path: state.tempGamePath,
      iconPath:
          state.tempIconPath == '' || state.tempIconPath == null
              ? null
              : state.tempIconPath,
    );
    add(AddGames(game));
    await Future.delayed(Duration(milliseconds: 100));
    emit(state.copyWith(tempGamePath: '', tempIconPath: ''));
  }
}
