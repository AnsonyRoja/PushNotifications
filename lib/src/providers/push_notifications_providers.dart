import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProviders {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? serverKey = "AAAA_vG2_Ao:APA91bHf47dJftk6P67GLtvo1BzJqRf8Gi6BQ70NXj6XniLRXr5ME1XZhDiPJZtmNiZvS8ZBZNla1Hke1h4Mi0S_wiI-ytduOgUxYqvd1B-sp0qAqOMpVcoptsUEDkkueeE_3W18trbH"; // Reemplaza con tu clave del servidor de FCM
   String? targetToken = "coiw5HTbR4uBFMh_8NnENk:APA91bHSFnnaJXE0kzXN7ngtOD-ENnqMYNSEi324b5Wa5wC8s9eFBVD38XNfqvwC61Tp7UvLTEl9k3i3qtfftDcLkXY7AW2tGSqZfaGQwOhnHBqfEuSuQi5cpvf-347w-u_I8ioFVRx5"; 

      // podria manejar un mapa un entero lo que sea
      final _mensajesStreamController = StreamController<String>.broadcast();
      Stream<String> get mensajes => _mensajesStreamController.stream;


  void initNotifications() {
    _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token) {
      print('==== FCM Token ====');
      print(token);


    });

Timer.periodic(const Duration(minutes: 35), (timer) {
              _enviarNotificacionPeriodica();

    });
        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          print('A new event was published! ${message.data}');
                final notification = message.notification;

                var argumento = 'no-data';

                if(Platform.isAndroid){

              argumento = message.data['comida'] ?? 'no-data';
                  print(argumento);
                }

                _mensajesStreamController.sink.add(argumento);

              if (notification != null) {
              // Acceder al cuerpo de la notificación
              final body = notification.title;
              print('Notification body: $body');
      
      }



        });    

            FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Manejar el clic en la notificación cuando la aplicación está en segundo plano
      print('A new onMessageOpenedApp event was published! ${message.data}');
      final notification = message.notification;

      if (notification != null) {
        // Acceder al cuerpo de la notificación
        final body = notification.title;
        print('Notification body on open: $body');

      }

        if (message.data != null && message.data.containsKey('tipo')) {
        _mensajesStreamController.sink.add(message.data['tipo']);
        } else {
        _mensajesStreamController.sink.add('Valor de comida es nulo o no está presente');
        }

      // Aquí puedes realizar cualquier acción adicional cuando se hace clic en la notificación
    });
       

  }

  dispose (){
    _mensajesStreamController.close();

  }

  

  void _enviarNotificacionPeriodica() async {
  // Configura la información de la notificación
  var notification = {
    'title': 'Título de la notificación',
    'body': 'Cuerpo de la notificación',
    'image': 'https://i.pinimg.com/originals/ce/c8/a6/cec8a6239de29acbfcfee0ccec995b9f.png', // Reemplaza con la URL de la imagen que deseas mostrar
    'icon': 'mi_icono', // Reemplaza con el nombre de tu recurso de notificación

  };

  // Configura la información adicional (data)
  var data = {
  
    'tipo': 'actualizacion', // Agrega los datos que desees enviar
    'mensaje': 'Esto es un mensaje de actualización',
  
  };

  // Configura la solicitud HTTP
  var headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  var body = {
    'notification': notification,
    'data': data, // Agrega la sección 'data' con los datos adicionales
    'to': targetToken,
  };

  // Realiza la solicitud HTTP POST
  var response = await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: headers,
    body: jsonEncode(body),
  );

  // Maneja la respuesta
  if (response.statusCode == 200) {
    print('Notificación enviada correctamente.');
  } else {
    print('Error al enviar la notificación. Código de estado: ${response.statusCode}');
  }


}


}


