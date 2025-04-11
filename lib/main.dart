import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flux/core/router/app_router.dart';
import 'package:flux/core/router/routes.dart';

 void main() {
  runApp(MyApp());
 
 }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flux',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Off-white color
          ),
          onGenerateRoute: AppRouter.generateRoute,
        initialRoute: Routes.home,
        );
      },
    );
  }
}


 