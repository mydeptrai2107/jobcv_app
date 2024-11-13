import 'package:hive_flutter/hive_flutter.dart';

import 'skill_model.dart';

class SkillModelAdapter extends TypeAdapter<SkillModel> {
  @override
  final int typeId = 2;

  @override
  SkillModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fiels = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return SkillModel(
        nameSkill: fiels[0] as String, description: fiels[1] as String);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  void write(BinaryWriter writer, SkillModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nameSkill)
      ..writeByte(1)
      ..write(obj.description);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
