// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_workout_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DietWorkoutPlanAdapter extends TypeAdapter<DietWorkoutPlan> {
  @override
  final int typeId = 6;

  @override
  DietWorkoutPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietWorkoutPlan(
      clusterKey: fields[0] as String,
      dietPlan: (fields[1] as Map).cast<String, DayMeals>(),
      workoutPlan: (fields[2] as List).cast<String>(),
      createdAt: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DietWorkoutPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.clusterKey)
      ..writeByte(1)
      ..write(obj.dietPlan)
      ..writeByte(2)
      ..write(obj.workoutPlan)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietWorkoutPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayMealsAdapter extends TypeAdapter<DayMeals> {
  @override
  final int typeId = 1;

  @override
  DayMeals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayMeals(
      breakfast: fields[0] as String,
      dinner: fields[1] as String,
      lunch: fields[2] as String,
      snacks: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DayMeals obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.breakfast)
      ..writeByte(1)
      ..write(obj.dinner)
      ..writeByte(2)
      ..write(obj.lunch)
      ..writeByte(3)
      ..write(obj.snacks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayMealsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
