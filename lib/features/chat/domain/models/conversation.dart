import 'package:mahe_chat/domain/models/user/user.dart';

class Conversation {
  final String? id;
  final List<Profile>? participants;
  final String? name;
  final bool? isGroup;

  Conversation({
    required this.id,
    required this.participants,
    required this.name,
    required this.isGroup,
  });
  // Convert JSON to Conversation
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((userJson) => Profile.fromJson(userJson))
              .toList()
          : null,
      name: json['name'],
      isGroup: json['isGroup'],
    );
  }
}
