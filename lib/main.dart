import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/config/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'blocs/blocs.dart';
import 'config/app_route.dart';
import 'config/theme/theme.dart';
import 'firebase_options.dart';
import 'screen/admin/components/menu_app_controller.dart';
import 'repository/repository.dart';
import 'screen/screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Bloc.observer = const AppObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedService.init();
  // final firebaseMessaging = FirebaseMessaging.instance;
  // await firebaseMessaging.requestPermission();
  // final token = await firebaseMessaging.getToken();
  // print('token: $token');
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message ${message.messageId}');
// }
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AuthEventStarted()),
        ),
        BlocProvider(
          create: (_) => BookBloc(BookRepository(),
          )..add(LoadBooks()),
        ),
        BlocProvider(
          create: (_) => UserBloc(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          )..add(LoadUser()),
        ),
        BlocProvider(
          create: (_) => ListUserBloc(
            userRepository: UserRepository(),
          )..add(LoadListUser()),
        ),
        ChangeNotifierProvider(create: (context) => MenuAppController()),
        BlocProvider(
          create: (_) => LibraryBloc(
            LibraryRepository()),
        ),
        BlocProvider(
            create: (_) =>
                ChaptersBloc(ChaptersRepository(),)),
        BlocProvider(
          create: (_) => HistoryBloc(
            HistoryRepository()),
        ),
        BlocProvider(
          create: (_) => NoteBloc(
           NoteRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'E Book App',
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        // darkTheme: darkTheme,
        // themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
        navigatorKey: navigatorKey,
        // navigatorObservers: <NavigatorObserver>[MyApp.observer],
      ),
    );
  }
}
