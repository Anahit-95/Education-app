import 'package:educational_app/core/common/app/provider/course_of_the_day_notifier.dart';
import 'package:educational_app/core/common/app/provider/notification_notifier.dart';
import 'package:educational_app/core/common/app/provider/user_provider.dart';
import 'package:educational_app/core/res/colours.dart';
import 'package:educational_app/core/res/fonts.dart';
import 'package:educational_app/core/services/injection_container.dart';
import 'package:educational_app/core/services/router.dart';
import 'package:educational_app/firebase_options.dart';
import 'package:educational_app/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => CourseOfTheDayNotifier()),
        ChangeNotifierProvider(
            create: (_) => NotificationNotifier(sl<SharedPreferences>())),
      ],
      child: MaterialApp(
        title: 'Educational App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: Fonts.poppins,
          appBarTheme: const AppBarTheme(color: Colors.transparent),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colours.primaryColour,
          ),
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
