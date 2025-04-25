import 'package:intl/date_symbol_data_local.dart';
import 'package:mahe_chat/app/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // static const primeColor = Color.fromARGB(255, 209, 153, 33);
  static const primeColor = Color.fromARGB(255, 33, 124, 209);

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "en";
    initializeDateFormatting();
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      //   AppLocale.delegate,
      // ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      locale: const Locale("en"),
      title: 'alkhalil chat',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
        seedColor: primeColor,
        brightness: Brightness.dark,
        tertiary: const Color.fromARGB(255, 92, 134, 240),
        error: const Color.fromARGB(255, 240, 92, 108),
      )).copyWith(
          // primaryTextTheme: GoogleFonts.inderTextTheme(),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            circularTrackColor: primeColor,
          ),
          dividerTheme: const DividerThemeData(
            endIndent: 10,
            indent: 10,
          )),
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
        seedColor: primeColor,
        brightness: Brightness.light,
        tertiary: const Color.fromARGB(255, 92, 134, 240),
        error: const Color.fromARGB(255, 240, 92, 108),
      )).copyWith(
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            circularTrackColor: primeColor,
          ),
          dividerTheme: const DividerThemeData(
            endIndent: 10,
            indent: 10,
          )),
      home: const HomePage(),
    );
  }
}

String getLanguageCode(String localeString) {
  // Split the locale string into the language code and the country code.
  List<String> parts = localeString.split('_');

  // Return the language code.
  return parts[0];
}
