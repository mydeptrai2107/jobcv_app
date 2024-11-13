import 'package:hive_flutter/hive_flutter.dart';

import 'user_model_hive.dart';

class UserModelAdapter extends TypeAdapter<UserModelHive> {
  @override
  final int typeId = 3;

  @override
  UserModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fiels = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return UserModelHive(
        firstName: fiels[0] as String,
        lastName: fiels[1] as String,
        phone: fiels[2] as String,
        id: fiels[3] as String,
        gender: fiels[4] as String,
        avatar: fiels[5] as String);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  void write(BinaryWriter writer, UserModelHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.avatar);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
