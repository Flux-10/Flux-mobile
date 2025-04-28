import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flux/core/router/app_router.dart';
import 'package:flux/core/router/routes.dart';
import 'package:flux/core/theme/theme_provider.dart';
import 'package:flux/core/util/constants.dart';
import 'package:flux/core/util/dependency_injection.dart';
import 'package:provider/provider.dart';

// Custom BLoC observer for debugging
class SimpleBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    developer.log('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    developer.log('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    developer.log('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    developer.log('onTransition -- ${bloc.runtimeType}, $transition');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up BLoC observer
  Bloc.observer = SimpleBlocObserver();
  
  // Log application start
  developer.log('Starting Flux app');
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Listen to theme changes
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AppDependencies(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flux',
            theme: ThemeData(
              primaryColor: AppConstants.primary,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: AppConstants.primary,
                secondary: AppConstants.outlinebg,
                background: AppConstants.bg,
              ),
              scaffoldBackgroundColor: AppConstants.bg,
              appBarTheme: AppBarTheme(
                backgroundColor: AppConstants.bg,
                elevation: 0,
                iconTheme: IconThemeData(color: AppConstants.primary),
                titleTextStyle: TextStyle(color: AppConstants.primary),
              ),
              textTheme: TextTheme(
                bodyLarge: TextStyle(color: AppConstants.primary),
                bodyMedium: TextStyle(color: AppConstants.primary),
                bodySmall: TextStyle(color: AppConstants.labelText),
              ),
              inputDecorationTheme: InputDecorationTheme(
                fillColor: AppConstants.primarybg,
                labelStyle: TextStyle(color: AppConstants.labelText),
              ),
              iconTheme: IconThemeData(color: AppConstants.primary),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: Routes.onboard,
          );
        },
      ),
    );
  }
}


 