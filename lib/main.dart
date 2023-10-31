import 'package:e_book_app/Cubits/cubits.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LoginCubit(authRepository: AuthRepository()),
          child: const LoginScreen(),
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
                )..add(LoadedReview()))
      ],
      child: MaterialApp(
        title: 'E Book App',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}
