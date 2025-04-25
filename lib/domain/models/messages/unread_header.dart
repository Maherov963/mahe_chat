import 'package:equatable/equatable.dart';

/// A class that represents the header above the first unread message.
class UnreadHeaderData extends Equatable {
  const UnreadHeaderData({this.count});

  final int? count;

  @override
  List<Object?> get props => [];
}
