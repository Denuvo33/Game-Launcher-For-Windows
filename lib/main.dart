import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/Screen/home_screen.dart';
import 'package:game_launcher_windows/bloc/launcher_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Launher',
      home: BlocProvider(
        create: (context) => LauncherBloc(),
        child: const HomeScreen(),
      ),
    );
  }
}
