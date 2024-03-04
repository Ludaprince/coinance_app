import 'dart:convert';

import 'package:coinance/models/app_config.dart';
import 'package:coinance/pages/home_page.dart';
import 'package:coinance/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadconfig();
  registerHTTPService();
  runApp(const MyApp());
}

Future<void> loadconfig() async {
  String configContent = await rootBundle.loadString("assets/config/main.json");
  Map configData = jsonDecode(configContent);
  GetIt.instance.registerSingleton<AppConfig>(
    AppConfig(COIN_API_BASE_URL: configData["COIN_API_BASE_URL"],
    ),
  );
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coinance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromRGBO(88, 60 , 197, 1.0),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
