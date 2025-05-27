import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/Screen/add_games_screen.dart';
import 'package:game_launcher_windows/bloc/launcher_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final launcherBloc = context.read<LauncherBloc>();

    return Scaffold(
      body: BlocListener<LauncherBloc, LauncherState>(
        listener: (context, state) {
          if (state.launchGame) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) => const AlertDialog(
                    title: Text('Starting Game'),
                    content: Center(
                      heightFactor: 1,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
            );
          }
        },
        child: BlocBuilder<LauncherBloc, LauncherState>(
          builder: (context, state) {
            return state.games.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text('You dont have any game'),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddGamesScreen(),
                            ),
                          );
                        },
                        child: Text('Add Games'),
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children:
                        state.games.map((game) {
                          return GestureDetector(
                            onTap: () {
                              launcherBloc.add(LaunchGame(game));
                            },
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 164,
                                    height: 164,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                      image:
                                          game.iconPath != null
                                              ? DecorationImage(
                                                image: FileImage(
                                                  File(game.iconPath!),
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                              : null,
                                    ),
                                    child:
                                        game.iconPath == null
                                            ? const Icon(
                                              Icons.videogame_asset,
                                              size: 40,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    width: 164,
                                    child: Text(
                                      game.name ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 164,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            launcherBloc.add(DeleteGame(game));
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            context.read<LauncherBloc>().add(
                                              LaunchGame(game),
                                            );
                                          },
                                          icon: Icon(
                                            size: 40,
                                            Icons.play_arrow_rounded,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGamesScreen()),
          );
        },
      ),
    );
  }
}
