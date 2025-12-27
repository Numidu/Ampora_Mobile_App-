import 'package:electric_app/provider/theme_provider.dart';
import 'package:electric_app/screens/AddVehicle.dart';
import 'package:electric_app/screens/BottomNavBar.dart';
import 'package:electric_app/screens/ChargerDetails.dart';
import 'package:electric_app/screens/ChargerScreen.dart';
import 'package:electric_app/screens/Login.dart';
import 'package:electric_app/screens/SettingScreen.dart';
import 'package:electric_app/screens/SignInScreen.dart';
import 'package:electric_app/screens/StationScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>(); // ✅ Now provider exists

    return MaterialApp(
      title: 'Electric App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'screens/Login',
      routes: {
        'screens/Login': (context) => const Login(),
        'screens/Home': (context) => const Bottomnavbar(),
        'screens/AddVehicle': (context) => const Addvehicle(),
        'screens/Settings': (context) => const Settingscreen(),
        'screens/SignIn': (context) => const Signinscreen(),
        'screen/Charger': (context) => const Chargerscreen(),
        'screen/ChargerDetails': (context) => const ChargerDetailsScreen(),
        'screen/Station': (context) => const Stationscreen(),
      },
      themeMode: theme.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
