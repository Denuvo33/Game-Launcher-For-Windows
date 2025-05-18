import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:game_launcher_windows/bloc/launcher_bloc.dart';
import 'package:game_launcher_windows/model/game_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final launcherBloc = context.read<LauncherBloc>();

    return Scaffold(
      body: BlocBuilder<LauncherBloc, LauncherState>(
        builder: (context, state) {
          return state.games.isEmpty
              ? Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Add Game'),
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
                            context.read<LauncherBloc>().add(LaunchGame(game));
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
                                          )
                                          : null,
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    game.name.split('.').first.toUpperCase(),
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
                                        onPressed: () {},
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

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['exe'],
          );

          if (result != null && result.files.single.path != null) {
            final gamePath = result.files.single.path!;
            final gameName = result.files.single.name;

            FilePickerResult? iconResult = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['ico', 'png', 'jpg', 'jpeg'],
            );

            String? iconPath;
            if (iconResult != null && iconResult.files.single.path != null) {
              iconPath = iconResult.files.single.path!;
            }
            launcherBloc.add(
              AddGames(
                GameModel(name: gameName, path: gamePath, iconPath: iconPath),
              ),
            );
          }
        },
      ),
    );
  }
}
