part of 'launcher_bloc.dart';

abstract class LauncherEvent {}

class LoadGames extends LauncherEvent {}

class AddGames extends LauncherEvent {
  final GameModel gameModel;
  AddGames(this.gameModel);
}

class LaunchGame extends LauncherEvent {
  final GameModel gameModel;
  LaunchGame(this.gameModel);
}

class DeleteGame extends LauncherEvent {
  final GameModel gameModel;
  DeleteGame(this.gameModel);
}
