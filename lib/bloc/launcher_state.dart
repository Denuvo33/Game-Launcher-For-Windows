part of 'launcher_bloc.dart';

class LauncherState extends Equatable {
  final List<GameModel> games;

  const LauncherState({this.games = const []});

  LauncherState copyWith({List<GameModel>? games}) {
    return LauncherState(games: games ?? this.games);
  }

  @override
  List<Object?> get props => [games];
}
