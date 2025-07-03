// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      uid: fields[0] as String,
      onboardingComplete: fields[1] as bool,
      bodyMetrics: fields[2] as BodyMetrics,
      healthProfile: fields[3] as HealthProfile,
      fitnessGoals: fields[4] as FitnessGoals,
      lastUpdated: fields[5] as DateTime,
      name: fields[6] as String,
      username: fields[7] as String,
      email: fields[8] as String,
      streak: fields[9] as int,
      achievements: (fields[10] as List).cast<String>(),
      caloriesIntake: fields[11] as double,
      caloriesTarget: fields[12] as double,
      caloriesBurned: fields[13] as double,
      caloriesBurnTarget: fields[14] as double,
      waterIntake: fields[15] as double,
      waterTarget: fields[16] as double,
      waterFrequency: fields[17] as int,
      waterFreqTarget: fields[18] as int,
      sleepHours: fields[19] as int,
      sleepTarget: fields[20] as int,
      sleepQuality: fields[21] as String,
      logValidityDate: fields[22] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.onboardingComplete)
      ..writeByte(2)
      ..write(obj.bodyMetrics)
      ..writeByte(3)
      ..write(obj.healthProfile)
      ..writeByte(4)
      ..write(obj.fitnessGoals)
      ..writeByte(5)
      ..write(obj.lastUpdated)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.username)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.streak)
      ..writeByte(10)
      ..write(obj.achievements)
      ..writeByte(11)
      ..write(obj.caloriesIntake)
      ..writeByte(12)
      ..write(obj.caloriesTarget)
      ..writeByte(13)
      ..write(obj.caloriesBurned)
      ..writeByte(14)
      ..write(obj.caloriesBurnTarget)
      ..writeByte(15)
      ..write(obj.waterIntake)
      ..writeByte(16)
      ..write(obj.waterTarget)
      ..writeByte(17)
      ..write(obj.waterFrequency)
      ..writeByte(18)
      ..write(obj.waterFreqTarget)
      ..writeByte(19)
      ..write(obj.sleepHours)
      ..writeByte(20)
      ..write(obj.sleepTarget)
      ..writeByte(21)
      ..write(obj.sleepQuality)
      ..writeByte(22)
      ..write(obj.logValidityDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BodyMetricsAdapter extends TypeAdapter<BodyMetrics> {
  @override
  final int typeId = 1;

  @override
  BodyMetrics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BodyMetrics(
      height: fields[0] as double?,
      weight: fields[1] as double?,
      age: fields[4] as int?,
      gender: fields[5] as String?,
      goalWeight: fields[2] as double?,
      bodyFat: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, BodyMetrics obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.height)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.goalWeight)
      ..writeByte(3)
      ..write(obj.bodyFat)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.gender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyMetricsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthProfileAdapter extends TypeAdapter<HealthProfile> {
  @override
  final int typeId = 2;

  @override
  HealthProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthProfile(
      conditions: (fields[0] as List).cast<String>(),
      medications: fields[1] as String?,
      injuries: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthProfile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.conditions)
      ..writeByte(1)
      ..write(obj.medications)
      ..writeByte(2)
      ..write(obj.injuries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FitnessGoalsAdapter extends TypeAdapter<FitnessGoals> {
  @override
  final int typeId = 3;

  @override
  FitnessGoals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FitnessGoals(
      primaryGoal: fields[0] as FitnessGoal,
      activityLevel: fields[1] as ActivityLevel,
      workoutDaysPerWeek: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FitnessGoals obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.primaryGoal)
      ..writeByte(1)
      ..write(obj.activityLevel)
      ..writeByte(2)
      ..write(obj.workoutDaysPerWeek);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessGoalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
