import 'package:e_book_app/config/shared_preferences.dart';
import 'package:e_book_app/config/theme/theme_provider.dart';
import 'package:e_book_app/cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'blocs/blocs.dart';
import 'config/app_route.dart';
import 'config/theme/theme.dart';
import 'firebase_options.dart';
import 'repository/repository.dart';
import 'screen/screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedService.init();
  final bool? isDark = SharedService.getTheme();
  runApp(MyApp(isDark: isDark ?? false));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isDark});

  @override
  State<MyApp> createState() => _MyAppState();

  final bool isDark;
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ForgotPasswordCubit(
            authRepository: AuthRepository(),
          ),
          child: const EnterEmailScreen(),
        ),
        BlocProvider(
          create: (_) => SignupCubit(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          ),
          child: const SignupScreen(),
        ),
        BlocProvider(
          create: (_) => LoginCubit(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          ),
          child: const LoginScreen(),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AuthEventStarted()),
        ),
        BlocProvider(
          create: (_) => BookBloc(
            BookRepository(),
          )..add(LoadBooks()),
        ),
        BlocProvider(
          create: (_) => ListUserBloc(
            UserRepository(),
          )..add(LoadListUser()),
        ),
        BlocProvider(
          create: (_) => LibraryBloc(LibraryRepository())..add(LoadLibrary()),
        ),
        BlocProvider(
            create: (_) => ReviewBloc(ReviewRepository())..add(LoadedReview())),
        BlocProvider(
          create: (_) => NoteBloc(
            NoteRepository(),
          ),
        ),
        BlocProvider(
            create: (_) =>
                CategoryBloc(CategoryRepository())..add(LoadCategory())),
        BlocProvider(
          create: (_) => HistoryBloc(
            HistoryRepository(),
          )..add(TopViewHistory()),
        ),
      ],
      child: ChangeNotifierProvider(
          create: (BuildContext context) => ThemeProvider(widget.isDark),
          builder: (context, snapshot) {
            final settings = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              title: 'E Book App',
              debugShowCheckedModeBanner: false,
              theme: settings.themeData,
              // darkTheme: darkTheme,
              // themeMode: ThemeMode.system,
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: SplashScreen.routeName,
              navigatorKey: navigatorKey,
              // navigatorObservers: <NavigatorObserver>[MyApp.observer],
            );
          }),
    );
  }
}
