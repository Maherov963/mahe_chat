import 'package:equatable/equatable.dart';

class DateHeader extends Equatable {
  /// Creates a date header.
  const DateHeader({
    required this.dateTime,
    required this.text,
  });

  final DateTime dateTime;

  final String text;

  @override
  List<Object> get props => [text, dateTime];
}
