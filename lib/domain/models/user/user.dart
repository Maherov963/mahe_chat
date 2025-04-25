import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class User extends Equatable {
  const User({
    this.bio,
    this.id,
    this.firstName,
    this.dateOfBirth,
    this.email,
    this.lastName,
    this.interests,
    this.gender,
    this.location,
    this.password,
    this.phone,
    this.profilePicture,
    this.token,
    this.username,
  });
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? username;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? token;
  @HiveField(4)
  final String? phone;
  @HiveField(5)
  final String? password;
  @HiveField(6)
  final String? firstName;
  @HiveField(7)
  final String? lastName;
  @HiveField(8)
  final DateTime? dateOfBirth;
  @HiveField(9)
  final int? gender;
  @HiveField(10)
  final String? profilePicture;
  @HiveField(11)
  final String? bio;
  @HiveField(12)
  final String? location;
  @HiveField(13)
  final List<String>? interests;
  String get getFullName => firstName == null && lastName == null
      ? "$username"
      : "$firstName $lastName";

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  User copy() => User.fromJson(toJson());
  @override
  List<Object?> get props => [
        id,
      ];
}
