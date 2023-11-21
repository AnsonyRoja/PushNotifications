import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prueba_notificacion/firebase_options.dart';
import 'package:prueba_notificacion/src/pages/home_page.dart';
import 'package:prueba_notificacion/src/pages/mensaje_page.dart';
import 'package:prueba_notificacion/src/providers/push_notifications_providers.dart';


void main()async {

    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());

}




class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  void initState(){

      super.initState();

      final pushProvider = PushNotificationProviders();

      pushProvider.initNotifications();
      
      pushProvider.mensajes.listen((data) {

        // Navigator.pushNamed(context, 'mensaje');
        print('Argumento desde main: $data');

        navigatorKey.currentState?.pushNamed('mensaje', arguments: data);

      });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            title: 'Push Local',
            initialRoute: 'home',

            routes: {
              'home' : (BuildContext context ) => const HomePage(),
              'mensaje' : (BuildContext context ) => const MensajePage(),

            },


    );
  }
}