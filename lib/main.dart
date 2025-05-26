import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_launcher_windows/Screen/home_screen.dart';
import 'package:game_launcher_windows/bloc/launcher_bloc.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  windowManager.ensureInitialized();

  windowManager.setMinimumSize(const Size(800, 600));

  runApp(BlocProvider(create: (context) => LauncherBloc(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      title: 'Game Launher',
      home: HomeScreen(),
    );
  }
}
