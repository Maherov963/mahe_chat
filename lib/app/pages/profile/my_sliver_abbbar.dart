import 'package:mahe_chat/app/components/certified_account.dart';
import 'package:mahe_chat/app/components/image_handler.dart';
import 'package:mahe_chat/app/components/image_view.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

class UserProfileAppBar extends StatefulWidget {
  const UserProfileAppBar({
    super.key,
    this.file,
    required this.scrollController,
    required this.firstLastName,
    this.certified = false,
    this.actions,
  });
  final String firstLastName;
  final String? file;
  final bool certified;
  final List<Widget>? actions;
  final ScrollController scrollController;
  @override
  State<UserProfileAppBar> createState() => _UserProfileAppBarMobileState();
}

class _UserProfileAppBarMobileState extends State<UserProfileAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// Animation to change user DP radius on scroll
  late final Animation<double> _dpRadiusAnimation;

  /// Animation to slide user name from left to right (behind user DP)
  late final Animation<double> _nameLeftAnimation;

  /// Animation to clip user name behind user DP (also slide to right)
  late final Animation<double> _nameWidthAnimation;

  /// AppBar expanded height
  static const _expandedHeight = 130.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    widget.scrollController.addListener(_scrollListener);

    _dpRadiusAnimation = Tween<double>(
      begin: 55,
      end: 20,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    // Start slide animation on 50%
    _nameLeftAnimation = Tween<double>(
      begin: 5,
      end: 60,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1, curve: Curves.easeIn),
      ),
    );

    // User name clipping, from 40% - 80%
    _nameWidthAnimation = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  /// Update animation value on scroll
  void _scrollListener() {
    final offset = widget.scrollController.offset;
    const max = _expandedHeight - kToolbarHeight;
    // Convert offset range to animation range (0-1)
    final value = (offset / max).clamp(0.0, 1.0);
    if (value != _controller.value) _controller.value = value;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final topPadding = mediaQuery.padding.top;
    final theme = Theme.of(context);
    //final customColors = CustomColors.of(context);

    // Animate user DP form center to top left corner on scroll
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SliverAppBar(
          actions: widget.actions,
          leading: BackButton(
            // color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: ColorTween(
            begin: theme.scaffoldBackgroundColor,
            end: theme.appBarTheme.backgroundColor,
          ).evaluate(
            CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.3, 1, curve: Curves.ease),
            ),
          ),
          pinned: true,
          expandedHeight: _expandedHeight,
          flexibleSpace: Stack(
            children: [
              // User dp and user name.
              // Using nested Stack to hide username behind user dp.
              Positioned.directional(
                textDirection: Directionality.of(context),
                top: (kToolbarHeight - 20 * 2) / 2 + topPadding,
                start: Tween<double>(
                  begin: screenWidth / 2 - (55 * 2 / 2),
                  end: 50,
                ).evaluate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.ease,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // User name
                    Positioned.directional(
                      textDirection: Directionality.of(context),
                      start: _nameLeftAnimation.value,
                      child: ClipRect(
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          widthFactor: _nameWidthAnimation.value,
                          child: CertifiedAccount(
                            name: widget.firstLastName,
                            certified: widget.certified,
                          ),
                        ),
                      ),
                    ),
                    Hero(
                      tag: 1,
                      child: ImageHandler(
                        path: widget.file,
                        isCircular: true,
                        onTap: () async {
                          await context.pushTransparentRoute(
                            const MyImageView(
                              name: "maher ghieh",
                              link: "",
                              tag: 1,
                            ),
                          );
                        },
                        width: _dpRadiusAnimation.value * 2,
                        hight: _dpRadiusAnimation.value * 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
