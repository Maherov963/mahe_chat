import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum ParsedType { email, phone, url, custom }

/// RegexOptions
class RegexOptions {
  /// Creates a RegexOptions object
  /// If `multiLine` is enabled, then `^` and `$` will match the beginning and
  ///  end of a _line_, in addition to matching beginning and end of input,
  ///  respectively.
  ///
  ///  If `caseSensitive` is disabled, then case is ignored.
  ///
  ///  If `unicode` is enabled, then the pattern is treated as a Unicode
  ///  pattern as described by the ECMAScript standard.
  ///
  ///  If `dotAll` is enabled, then the `.` pattern will match _all_ characters,
  ///  including line terminators.
  const RegexOptions({
    this.multiLine = false,
    this.caseSensitive = true,
    this.unicode = false,
    this.dotAll = false,
  });

  final bool multiLine;
  final bool unicode;
  final bool caseSensitive;
  final bool dotAll;
}

/// Email Regex - A predefined type for handling email matching
const emailPattern = r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b";

/// URL Regex - A predefined type for handling URL matching
const urlPattern =
    r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=]*)";

/// Phone Regex - A predefined type for handling phone matching
const phonePattern =
    r"(\+?( |-|\.)?\d{1,2}( |-|\.)?)?(\(?\d{3}\)?|\d{3})( |-|\.)?(\d{3}( |-|\.)?\d{4})";

/// A MatchText class which provides a structure for [ParsedText] to handle
/// Pattern matching and also to provide custom [Function] and custom [TextStyle].
class MatchText {
  /// Used to enforce Predefined regex to match from
  ParsedType type;

  /// If no [type] property is explicitly defined then this propery must be
  /// non null takes a [regex] string
  String? pattern;

  /// Takes a custom style of [TextStyle] for the matched text widget
  TextStyle? style;

  /// A custom [Function] to handle onTap.
  Function(String)? onTap;
  Function(String)? onLongTap;

  /// A callback function that takes two parameter String & pattern
  ///
  /// @param str - is the word that is being matched
  /// @param pattern - pattern passed to the MatchText class
  ///
  /// eg: Your str is 'Mention [@michel:5455345]' where 5455345 is ID of this user
  /// and @michel the value to display on interface.
  /// Your pattern for ID & username extraction : `/\[(@[^:]+):([^\]]+)\]/`i
  /// Displayed text will be : Mention `@michel`
  Map<String, String> Function({
    required String str,
    required String pattern,
  })? renderText;

  /// A callback function that takes the [text] the matches the [pattern] and returns
  /// the [Widget] to be displayed inside a [WidgetSpan]
  Widget Function({
    required String text,
    required String pattern,
  })? renderWidget;

  /// Creates a MatchText object
  MatchText({
    this.type = ParsedType.custom,
    this.pattern,
    this.style,
    this.onTap,
    this.onLongTap,
    this.renderText,
    this.renderWidget,
  });
}

/// Parse text and make them into multiple Flutter Text widgets
class ParsedText extends StatefulWidget {
  /// If non-null, the style to use for the global text.
  ///
  /// It takes a [TextStyle] object as it's property to style all the non links text objects.
  final TextStyle? style;

  /// Takes a list of [MatchText] object.
  ///
  /// This list is used to find patterns in the String and assign onTap [Function] when its
  /// tapped and also to provide custom styling to the linkify text
  final List<MatchText> parse;

  /// Text that is rendered
  ///
  /// Takes a [String]
  final String text;

  /// A text alignment property used to align the the text enclosed
  ///
  /// Uses a [TextAlign] object and default value is [TextAlign.start]
  final TextAlign alignment;

  /// A text alignment property used to align the the text enclosed
  ///
  /// Uses a [TextDirection] object and default value is [TextDirection.start]
  final TextDirection? textDirection;

  /// Whether the text should break at soft line breaks.
  ///
  ///If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool softWrap;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  final double textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.text.DefaultTextStyle.textWidthBasis}
  final TextWidthBasis textWidthBasis;

  /// Make this text selectable.
  ///
  /// SelectableText does not support softwrap, overflow, textScaleFactor
  final bool selectable;

  /// onTap function for the whole widget
  final Function? onTap;

  /// Global regex options for the whole string,
  ///
  /// Note: Removed support for regexOptions for MatchText and now it uses global regex options.
  final RegexOptions regexOptions;

  /// Creates a parsedText widget
  ///
  /// [text] paramtere should not be null and is always required.
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  const ParsedText({
    Key? key,
    required this.text,
    this.parse = const <MatchText>[],
    this.style,
    this.alignment = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.maxLines,
    this.onTap,
    this.selectable = false,
    this.regexOptions = const RegexOptions(),
  }) : super(key: key);

  @override
  State<ParsedText> createState() => _ParsedTextState();
}

class _ParsedTextState extends State<ParsedText> {
  @override
  Widget build(BuildContext context) {
    String newString = widget.text;

    Map<String, MatchText> mapping0 = <String, MatchText>{};

    for (var e in widget.parse) {
      if (e.type == ParsedType.email) {
        mapping0[emailPattern] = e;
      } else if (e.type == ParsedType.phone) {
        mapping0[phonePattern] = e;
      } else if (e.type == ParsedType.url) {
        mapping0[urlPattern] = e;
      } else {
        mapping0[e.pattern!] = e;
      }
    }

    final pattern = '(${mapping0.keys.toList().join('|')})';

    List<InlineSpan> widgets = [];

    newString.splitMapJoin(
      RegExp(pattern),
      onMatch: (Match match) {
        final matchText = match[0];

        final mapping = mapping0[matchText!] ??
            mapping0[mapping0.keys.firstWhere((element) {
              final reg = RegExp(
                element,
              );
              return reg.hasMatch(matchText);
            }, orElse: () {
              return '';
            })];

        InlineSpan child;

        if (mapping != null) {
          child = TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTapUp = (details) {
                showBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          matchText,
                          maxLines: 3,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      CupertinoListTile(
                        onTap: () {
                          mapping.onLongTap?.call(matchText);
                          Navigator.pop(context);
                        },
                        title: Text(
                          "Copy",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      CupertinoListTile(
                        onTap: () {
                          mapping.onTap?.call(matchText);
                          Navigator.pop(context);
                        },
                        title: Text(
                          "Open",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                );
              },
            text: matchText,
            style: (mapping.style ?? widget.style),
          );
        } else {
          child = TextSpan(
            text: matchText,
            style: widget.style,
          );
        }

        widgets.add(child);

        return '';
      },
      onNonMatch: (String text) {
        widgets.add(TextSpan(
          text: text,
          style: widget.style,
        ));

        return '';
      },
    );

    if (widget.selectable) {
      return SelectableText.rich(
        TextSpan(children: <InlineSpan>[...widgets], style: widget.style),
        maxLines: widget.maxLines,
        strutStyle: widget.strutStyle,
        textWidthBasis: widget.textWidthBasis,
        textAlign: widget.alignment,
        textDirection: widget.textDirection,
        // onTap: onTap as void Function()?,
      );
    }

    return RichText(
      // softWrap: softWrap,
      // overflow: overflow,
      // textScaleFactor: textScaleFactor,
      // maxLines: maxLines,
      // strutStyle: strutStyle,
      // textWidthBasis: textWidthBasis,
      // textAlign: alignment,
      // textDirection: textDirection,
      text: TextSpan(
        // text: '',
        children: widgets,
        style: widget.style,
      ),
    );
  }
}
