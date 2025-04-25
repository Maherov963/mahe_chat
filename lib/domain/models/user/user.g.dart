// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      bio: fields[11] as String?,
      id: fields[0] as int?,
      firstName: fields[6] as String?,
      dateOfBirth: fields[8] as DateTime?,
      email: fields[2] as String?,
      lastName: fields[7] as String?,
      interests: (fields[13] as List?)?.cast<String>(),
      gender: fields[9] as int?,
      location: fields[12] as String?,
      password: fields[5] as String?,
      phone: fields[4] as String?,
      profilePicture: fields[10] as String?,
      token: fields[3] as String?,
      username: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.firstName)
      ..writeByte(7)
      ..write(obj.lastName)
      ..writeByte(8)
      ..write(obj.dateOfBirth)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.profilePicture)
      ..writeByte(11)
      ..write(obj.bio)
      ..writeByte(12)
      ..write(obj.location)
      ..writeByte(13)
      ..write(obj.interests);
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

User _$UserFromJson(Map<String, dynamic> json) => User(
      bio: json['bio'] as String?,
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      email: json['email'] as String?,
      lastName: json['lastName'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      gender: json['gender'] as int?,
      location: json['location'] as String?,
      password: json['password'] as String?,
      phone: json['phone'] as String?,
      profilePicture: json['profilePicture'] as String?,
      token: json['token'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'token': instance.token,
      'phone': instance.phone,
      'password': instance.password,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'profilePicture': instance.profilePicture,
      'bio': instance.bio,
      'location': instance.location,
      'interests': instance.interests,
    };
