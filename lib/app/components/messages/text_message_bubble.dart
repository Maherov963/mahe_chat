import 'package:mahe_chat/domain/models/messages/text_message.dart';
import 'package:mahe_chat/domain/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class TextMessageBubble extends StatelessWidget {
  final TextMessage message;
  final Profile currentUser;
  final String extraSpace;
  final TextStyle style;

  const TextMessageBubble({
    super.key,
    required this.message,
    required this.extraSpace,
    required this.currentUser,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      message.text + extraSpace,
      style: style,
    );

    // return ParsedText(
    //   parse: [
    //     MatchText(
    //       onTap: (urlText) async {
    //         final protocolIdentifierRegex = RegExp(
    //           r'^((http|ftp|https):\/\/)',
    //           caseSensitive: false,
    //         );
    //         if (!urlText.startsWith(protocolIdentifierRegex)) {
    //           urlText = 'https://$urlText';
    //         }
    //         final url = Uri.tryParse(urlText);
    //         if (url != null) {
    //           await launchUrl(
    //             url,
    //             mode: LaunchMode.platformDefault,
    //           );
    //         }
    //       },
    //       onLongTap: (p0) {
    //         Clipboard.setData(ClipboardData(text: p0));
    //         MySnackBar.showMySnackBar("link copied");
    //       },
    //       pattern: regexLink,
    //       style: style.copyWith(
    //         color: color8,
    //       ),
    //     ),
    //     MatchText(
    //       pattern: regexPhone,
    //       style: style.copyWith(
    //         color: color8,
    //       ),
    //       onTap: (p0) async {
    //         final content = 'tel:$p0';
    //         final url = Uri.tryParse(content);
    //         if (url != null) {
    //           await launchUrl(
    //             url,
    //             mode: LaunchMode.platformDefault,
    //           );
    //         }
    //       },
    //     ),
    //   ],
    //   style: style,
    //   text: message.text + extraSpace,
    // );
  }
}

/// Regex to check if text is email.
const regexEmail = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';
const regexPhone = r'[0-9]+[0-9]+[0-9]';

/// Regex to find all links in the text.
const regexLink =
    r'((http|ftp|https):\/\/)?([\w_-]+(?:(?:\.[\w_-]*[a-zA-Z_][\w_-]*)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?[^\.\s]';

class PatternStyle {
  PatternStyle(this.from, this.regExp, this.replace, this.textStyle);

  final Pattern from;
  final RegExp regExp;
  final String replace;
  final TextStyle textStyle;

  String get pattern => regExp.pattern;

  static PatternStyle get bold => PatternStyle(
        '*',
        RegExp('\\*[^\\*]+\\*'),
        '',
        const TextStyle(fontWeight: FontWeight.bold),
      );

  static PatternStyle get code => PatternStyle(
        '`',
        RegExp('`[^`]+`'),
        '',
        TextStyle(
          fontFamily: defaultTargetPlatform == TargetPlatform.iOS
              ? 'Courier'
              : 'monospace',
        ),
      );

  static PatternStyle get italic => PatternStyle(
        '_',
        RegExp('_[^_]+_'),
        '',
        const TextStyle(fontStyle: FontStyle.italic),
      );

  static PatternStyle get lineThrough => PatternStyle(
        '~',
        RegExp('~[^~]+~'),
        '',
        const TextStyle(decoration: TextDecoration.lineThrough),
      );
}
