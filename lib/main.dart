import 'package:e_book_app/cubits/cubits.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginCubit(
            authRepository: AuthRepository(),
          ),
          child: const LoginScreen(),
        ),
        BlocProvider(
          create: (_) => ChangePasswordCubit(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          ),
          child: const ChangePasswordScreen(),
        ),
        BlocProvider(
          create: (_) => EditProfileCubit(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          ),
          child: const EditProfileScreen(),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            authRepository: AuthRepository(),
          )..add(AuthEventStarted()),
        ),
        BlocProvider(
          create: (_) => BookBloc(
            bookRepository: BookRepository(),
          )..add(LoadBooks()),
        ),
        BlocProvider(
          create: (_) => CategoryBloc(categoryRepository: CategoryRepository())
            ..add(LoadCategory()),
        ),
        BlocProvider(
            create: (_) => AuthorBloc(
                  authorRepository: AuthorRepository(),
                )..add(LoadedAuthor())),
        BlocProvider(
          create: (_) => ReviewBloc(
            reviewRepository: ReviewRepository(),
          )..add(LoadedReview()),
        ),
        BlocProvider(
            create: (_) => AuthorBloc(
                  authorRepository: AuthorRepository(),
                )..add(LoadedAuthor())),
        BlocProvider(
            create: (_) => ReviewBloc(
                  reviewRepository: ReviewRepository(),
                )..add(LoadedReview())),
        BlocProvider(
          create: (_) => UserBloc(
            authRepository: AuthRepository(),
            userRepository: UserRepository(),
          )..add(LoadUser()),
        ),
        ChangeNotifierProvider(create: (context) => MenuAppController())
      ],
      child: MaterialApp(
        title: 'E Book App',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
        navigatorObservers: <NavigatorObserver>[observer],
      ),
    );
  }
}
