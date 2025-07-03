// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_level_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityLevelAdapter extends TypeAdapter<ActivityLevel> {
  @override
  final int typeId = 4;

  @override
  ActivityLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityLevel.Beginner;
      case 2:
        return ActivityLevel.Intermediate;
      case 3:
        return ActivityLevel.Advanced;
      default:
        return ActivityLevel.Beginner;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityLevel obj) {
    switch (obj) {
      case ActivityLevel.Beginner:
        writer.writeByte(0);
        break;
      case ActivityLevel.Intermediate:
        writer.writeByte(2);
        break;
      case ActivityLevel.Advanced:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
