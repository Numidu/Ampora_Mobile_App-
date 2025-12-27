import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/provider/theme_provider.dart';
import 'package:electric_app/screens/MyApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
