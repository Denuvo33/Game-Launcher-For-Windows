part of 'launcher_bloc.dart';

class LauncherState extends Equatable {
  final List<GameModel> games;
  final String? tempGamePath;
  final String? tempIconPath;
  final bool launchGame;

  const LauncherState({
    this.games = const [],
    this.tempGamePath,
    this.tempIconPath,
    this.launchGame = false,
  });

  LauncherState copyWith({
    List<GameModel>? games,
    String? tempGamePath,
    String? tempIconPath,
    bool? launchGame,
  }) {
    return LauncherState(
      games: games ?? this.games,
      tempGamePath: tempGamePath ?? this.tempGamePath,
      tempIconPath: tempIconPath ?? this.tempIconPath,
      launchGame: launchGame ?? this.launchGame,
    );
  }

  @override
  List<Object?> get props => [games, tempGamePath, tempIconPath, launchGame];
}
