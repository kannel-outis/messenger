// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePhoneContactsListAdapter extends TypeAdapter<HivePhoneContactsList> {
  @override
  final int typeId = 6;

  @override
  HivePhoneContactsList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePhoneContactsList(
      // phoneContacts: (fields[0] as List)
      //     .map((dynamic e) => (e as List)
      //         .map((dynamic e) => (e as Map).cast<String, dynamic>())
      //         .toList())
      //     .toList(),
      registeredContactsToMap: (fields[0] as List)
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList(),
      unRegisteredContactsToMap: (fields[1] as List)
          .map((e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, HivePhoneContactsList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.registeredContactsToMap)
      ..writeByte(1)
      ..write(obj.unRegisteredContactsToMap);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HivePhoneContactsListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
