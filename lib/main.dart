import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/screens/AddVehicle.dart';
import 'package:electric_app/screens/BottomNavBar.dart';
import 'package:electric_app/screens/ChargerDetails.dart';
import 'package:electric_app/screens/ChargerScreen.dart';
import 'package:electric_app/screens/Login.dart';
import 'package:electric_app/screens/SettingScreen.dart';
import 'package:electric_app/screens/SignInScreen.dart';
import 'package:electric_app/screens/StationScreen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ElECTRIC_APP());
}

class ElECTRIC_APP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Electric App',
        initialRoute: 'screens/Login',
        routes: {
          'screens/Login': (context) => const Login(),
          'screens/Home': (context) => const Bottomnavbar(),
          'screens/AddVehicle': (context) => const Addvehicle(),
          'screens/Settings': (context) => const Settingscreen(),
          'screens/SignIn': (context) => const Signinscreen(),
          'screen/Charger': (context) => const Chargerscreen(),
          'screen/ChargerDetails': (context) => const ChargerDetailsScreen(),
          'screen/Station': (context) => const Stationscreen()
        },
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
