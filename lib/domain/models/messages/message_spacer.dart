import 'package:equatable/equatable.dart';

/// A class that represents additional space between messages.
class MessageSpacer extends Equatable {
  /// Creates a MessageSpacer.
  const MessageSpacer({
    required this.height,
    required this.id,
  });

  /// Spacer's height.
  final double height;

  /// Unique ID of the spacer.
  final String id;

  /// Equatable props.
  @override
  List<Object> get props => [height, id];
}
