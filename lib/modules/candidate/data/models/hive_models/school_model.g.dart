import 'package:hive_flutter/hive_flutter.dart';
import 'experience_model.g.dart';
import 'school_model.dart';

class SchoolModelAdapter extends TypeAdapter<SchoolModel> {
  @override
  final int typeId = 1;
  @override
  SchoolModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return SchoolModel(
      nameSchool: fields[0] as String,
      to: fields[1] as DateTime,
      from: fields[2] as DateTime,
      major: fields[3] as String,
      description: fields[4] as String,
    );
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  void write(BinaryWriter writer, SchoolModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nameSchool)
      ..writeByte(1)
      ..write(obj.to)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.major)
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
