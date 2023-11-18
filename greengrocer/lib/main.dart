import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:greengrocer/src/constants/page_routes.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';

void main() {
  // Trecho de código que garante que todos os componentes necessários para a ação seguinte já estejam iniciados
  WidgetsFlutterBinding.ensureInitialized();

  // Injeção de Controlador na memória do aplicativo, podendo ser recuperado de qualquer lugar
  Get.put(AuthController());

  // Mais abaixo teremos o método assíncrono que define as possíveis orientações suportadas pelo app.
  // Nesta lista abaixo você tem todas estas orientações disponíveis:
  /*
    * DeviceOrientation.landscapeRight,
    * DeviceOrientation.landscapeLeft,
    * DeviceOrientation.portraitUp, 
    * DeviceOrientation.portraitDown,
 */

  // Aqui definimos apenas o modo retrato em pé, fazendo com que todo nosso app fique apenas nessa orientação, evitando o overflow
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GreenGrocer',
      theme: ThemeData(
        //primarySwatch: Colors.grey,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white.withAlpha(190),
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        //useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: PageRoutes.splashRoute,
      getPages: AppPages.pages,
    );
  }
}
