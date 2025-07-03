// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_goal_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FitnessGoalAdapter extends TypeAdapter<FitnessGoal> {
  @override
  final int typeId = 5;

  @override
  FitnessGoal read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FitnessGoal.weightLoss;
      case 1:
        return FitnessGoal.muscleGain;
      case 2:
        return FitnessGoal.maintenance;
      default:
        return FitnessGoal.weightLoss;
    }
  }

  @override
  void write(BinaryWriter writer, FitnessGoal obj) {
    switch (obj) {
      case FitnessGoal.weightLoss:
        writer.writeByte(0);
        break;
      case FitnessGoal.muscleGain:
        writer.writeByte(1);
        break;
      case FitnessGoal.maintenance:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessGoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
