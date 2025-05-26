import 'package:hive/hive.dart';

part 'game_model.g.dart';

@HiveType(typeId: 0)
class GameModel extends HiveObject {
  @HiveField(0)
  final String? path;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? iconPath;

  GameModel({required this.path, required this.name, this.iconPath});
}
