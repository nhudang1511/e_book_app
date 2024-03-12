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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Bloc.observer = const AppObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

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
            LibraryRepository(),
          )..add(LoadLibrary()),
        ),
        BlocProvider(
            create: (_) =>
                ChaptersBloc(ChaptersRepository(),)),
        BlocProvider(
          create: (_) => HistoryBloc(
            HistoryRepository())..add(LoadHistory()),
        ),
        BlocProvider(
          create: (_) => NoteBloc(
           NoteRepository(),
          )..add(LoadedNote()),
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
