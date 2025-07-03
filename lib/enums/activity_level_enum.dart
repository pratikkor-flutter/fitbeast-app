import 'package:hive/hive.dart';

part 'activity_level_enum.g.dart';

@HiveType(typeId: 4)
enum ActivityLevel {
  @HiveField(0)
  Beginner,

  @HiveField(2)
  Intermediate,

  @HiveField(3)
  Advanced,
}
