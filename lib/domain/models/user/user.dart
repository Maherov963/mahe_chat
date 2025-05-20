import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Profile extends Equatable {
  const Profile({
    this.bio,
    this.id,
    this.email,
    this.password,
    this.phone,
    this.profilePicture,
    this.token,
    this.age,
    this.username,
  });
  @HiveField(0)
  final String? id;
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
  final int? age;
  @HiveField(7)
  final String? profilePicture;
  @HiveField(8)
  final String? bio;
  factory Profile.fromUser(User user) {
    return Profile(
      id: user.uid,
      token: user.refreshToken,
      username: user.displayName,
      email: user.email,
    );
  }
  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory Profile.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Profile copy() => Profile.fromJson(toJson());
  @override
  List<Object?> get props => [
        id,
      ];
}
