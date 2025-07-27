import 'package:biznet_workforce_activity/app/di/injector.dart';
import 'package:biznet_workforce_activity/features/activity/presentation/bloc/activity_bloc.dart';
import 'package:biznet_workforce_activity/features/shared/permission_check_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupInjector();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ActivityBloc>(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Biznet Workforce Activity',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.light(),
            ),
            home: const PermissionCheckPage(),
          );
        },
      ),
    );
  }
}
