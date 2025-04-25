import 'package:equatable/equatable.dart';

/// A class that represents in bottom of the chat of who is typing now.
class TypingMessageData extends Equatable {
  const TypingMessageData({this.name});

  final String? name;
  static const id = "TypingMessageData";

  @override
  List<Object?> get props => [];
}
