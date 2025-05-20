// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 0;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      bio: fields[8] as String?,
      id: fields[0] as String?,
      email: fields[2] as String?,
      password: fields[5] as String?,
      phone: fields[4] as String?,
      profilePicture: fields[7] as String?,
      token: fields[3] as String?,
      age: fields[6] as int?,
      username: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.token)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.password)
      ..writeByte(6)
      ..write(obj.age)
      ..writeByte(7)
      ..write(obj.profilePicture)
      ..writeByte(8)
      ..write(obj.bio);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Profile _$UserFromJson(Map<String, dynamic> json) => Profile(
      bio: json['bio'] as String?,
      id: json['objectId'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      profilePicture: json['profilePicture'] as String?,
      token: json['sessionToken'] as String?,
      age: json['age'] is Map
          ? json['age']['savedNumber'] ?? json['age']['estimateNumber']
          : json['age'],
      username: json['username'] as String?,
    );

Map<String, dynamic> _$UserToJson(Profile instance) => <String, dynamic>{
      'objectId': instance.id,
      'username': instance.username,
      'email': instance.email,
      'sessionToken': instance.token,
      'phone': instance.phone,
      'password': instance.password,
      'age': instance.age,
      'profilePicture': instance.profilePicture,
      'bio': instance.bio,
    };
