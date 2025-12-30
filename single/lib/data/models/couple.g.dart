// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'couple.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoupleProfileAdapter extends TypeAdapter<CoupleProfile> {
  @override
  final int typeId = 0;

  @override
  CoupleProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoupleProfile(
      nameA: fields[0] as String,
      nameB: fields[1] as String,
      startDate: fields[2] as DateTime,
      avatarAPath: fields[3] as String?,
      avatarBPath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CoupleProfile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nameA)
      ..writeByte(1)
      ..write(obj.nameB)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.avatarAPath)
      ..writeByte(4)
      ..write(obj.avatarBPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoupleProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
