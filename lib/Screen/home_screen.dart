import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/Screen/add_games_screen.dart';
import 'package:game_launcher_windows/bloc/launcher_bloc.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController _searchGame = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final launcherBloc = context.read<LauncherBloc>();

    return Scaffold(
      body: BlocListener<LauncherBloc, LauncherState>(
        listener: (context, state) {
          if (state.launchGame) {
            showDialog(
              context: context,
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
            return launcherBloc.state.games.isEmpty && _searchGame.text.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        'You dont have any Games😢',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20,
                      children: [
                        SearchBar(
                          hintText: "Search Game",
                          controller: _searchGame,
                          onChanged: (value) {
                            launcherBloc.add(SearchGame(value));
                          },
                        ),
                        Row(
                          children: [
                            PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text('Date New'),
                                    value: 'Date New',
                                    onTap: () {
                                      launcherBloc.add(SortGame('Date New'));
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text('Date Old'),
                                    value: 'Date Old',
                                    onTap: () {
                                      launcherBloc.add(SortGame('Date Old'));
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text('Name'),
                                    value: 'Name',
                                    onTap: () {
                                      launcherBloc.add(SortGame('Name'));
                                    },
                                  ),
                                ];
                              },
                            ),
                            Text(launcherBloc.state.sort!),
                          ],
                        ),
                        Wrap(
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                                  launcherBloc.add(
                                                    DeleteGame(game),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<LauncherBloc>()
                                                      .add(LaunchGame(game));
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
                      ],
                    ),
                  ),
                );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
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
