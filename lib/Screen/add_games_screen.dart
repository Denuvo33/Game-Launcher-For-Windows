import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/bloc/launcher_bloc.dart';

class AddGamesScreen extends StatefulWidget {
  const AddGamesScreen({super.key});

  @override
  State<AddGamesScreen> createState() => _AddGamesScreenState();
}

class _AddGamesScreenState extends State<AddGamesScreen> {
  final TextEditingController title = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    title.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Games')),
      body: BlocBuilder<LauncherBloc, LauncherState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  ListTile(
                    title: Text(
                      state.tempGamePath == '' || state.tempGamePath == null
                          ? 'Game Path'
                          : state.tempGamePath!,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context.read<LauncherBloc>().add(PickGamePath());
                      },
                      icon: Icon(Icons.folder),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      state.tempIconPath == '' || state.tempIconPath == null
                          ? 'Icon Path (Optional)'
                          : state.tempIconPath ?? 'Icon Path (Optional)',
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context.read<LauncherBloc>().add(PickIconPath());
                      },
                      icon: Icon(Icons.folder),
                    ),
                  ),
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Game Name',
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (title.text.isEmpty && state.tempGamePath == null ||
                          state.tempGamePath == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please enter Game name or Game Path',
                            ),
                          ),
                        );
                        return;
                      }
                      ;
                      context.read<LauncherBloc>().add(
                        PickAndAddGame(title.text),
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Game Saved')));
                    },
                    child: Text('Save Game'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
