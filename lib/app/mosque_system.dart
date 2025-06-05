import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahe_chat/features/auth/domain/provider/auth_notifier.dart';
import 'package:mahe_chat/features/auth/presentation/pages/auth.dart';
<<<<<<< HEAD
import 'package:mahe_chat/features/call/video_call_page.dart';
=======
>>>>>>> origin/main
import 'package:mahe_chat/features/chat/presentation/pages/home.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // static const primeColor = Color.fromARGB(255, 209, 153, 33);
  static const primeColor = Color.fromARGB(255, 33, 124, 209);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(authProvider).getCashedUser();
      },
    );
    super.initState();
  }

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
      title: 'Mahechat',
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
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color.fromARGB(255, 52, 51, 58),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            labelStyle: TextStyle(color: Colors.grey.shade400),
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
          cardTheme: CardTheme(
            color: const Color(0xFF1E1E1E),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
<<<<<<< HEAD
      home:
          // HomePage(),
          FutureBuilder(
=======
<<<<<<< HEAD
      home: CallPage(
        userId: "",
      ),
      //  FutureBuilder(
      //   future: ref.read(authProvider).getCashedUser(),
      //   builder: (context, snapshot) {
      //     if (ref.read(authProvider).myUser == null) {
      //       return const AuthScreen();
      //     } else {
      //       return const ;
      //     }
      //   },
      // ),
=======
      home: 
      // HomePage(),
       FutureBuilder(
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
        future: ref.read(authProvider).getCashedUser(),
        builder: (context, snapshot) {
          if (ref.read(authProvider).myUser == null) {
            return const AuthScreen();
          } else {
            return const HomePage();
          }
        },
      ),
<<<<<<< HEAD
=======
>>>>>>> origin/main
>>>>>>> c3d9dd8539a2befed8f17a57d564e16b58c371f0
    );
  }
}

String getLanguageCode(String localeString) {
  // Split the locale string into the language code and the country code.
  List<String> parts = localeString.split('_');

  // Return the language code.
  return parts[0];
}
