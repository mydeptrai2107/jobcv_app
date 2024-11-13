import 'package:hive_flutter/hive_flutter.dart';

import 'experience_model.dart';

class ExperienceModelAdapter extends TypeAdapter<ExperienceModel> {
  @override
  final int typeId = 0;

  @override
  ExperienceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fiels = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return ExperienceModel(
        nameCompany: fiels[0] as String,
        to: fiels[1] as DateTime,
        from: fiels[2] as DateTime,
        position: fiels[3] as String,
        description: fiels[4] as String);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  void write(BinaryWriter writer, ExperienceModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nameCompany)
      ..writeByte(1)
      ..write(obj.to)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.description);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
