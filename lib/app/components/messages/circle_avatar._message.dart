import 'package:mahe_chat/app/utils/assets/assets_images.dart';
import 'package:flutter/material.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar({
    super.key,
    // required this.author,
    // this.onAvatarTap,
    // required this.tag,
  });

  // /// Author to show image and name initials from.
  // final User author;
  // final dynamic tag;

  // /// Called when user taps on an avatar.
  // final void Function(User)? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundImage: AssetImage(AssetImg.mine),
      radius: 16,
    );
  }
}
