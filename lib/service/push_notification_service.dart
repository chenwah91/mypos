import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
//    _notificationsPlugin.initialize(initializationSettings);
    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route) async{
      if(route != null){


        final routerFromMessage = route;
        print("onmessage home_pages >  $routerFromMessage");

        if(routerFromMessage == "billapp"){

            Navigator.pushNamed(context, routerFromMessage);

        }


      }
    });
  }

  static void display(RemoteMessage message) async {

    try {
      var id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "mypos_channel",
            "mypos_channel channel",
            importance: Importance.max,
            priority: Priority.high,
          )
      );


      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        " ${message.notification!.body}  Display Cust2",
        notificationDetails,
        payload: message.data["router"],
      );

    } on Exception catch (e) {
      print(e);
    }
  }



  static void displayX(var message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "mypos_channel",
            "mypos_channel channel",
            importance: Importance.max,
            priority: Priority.high,
          )
      );


      await _notificationsPlugin.show(
        id,
        message[0],
        "${ message[1]}  DisplayXXX",
        notificationDetails,
        payload: message[2],
      );

    } on Exception catch (e) {
      print(e);
    }
  }







}