
import 'package:flutter/material.dart';
import 'package:flutter_app/model/billing_item.dart';
import 'package:flutter_app/pages/billing_page.dart';
import 'package:flutter_app/service/push_notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'pages/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

//const AndroidNotificationChannel channel = AndroidNotificationChannel(
//    'high_importance_channel', // id
//    'High Importance Notifications', // title description iption
//    importance: Importance.high,
//    playSound: true);
//
//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//FlutterLocalNotificationsPlugin();
//

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

//  await Firebase.initializeApp();

  print( 'Main Dart show this  > message id :  ${message.messageId}');
  if(message.notification != null) {

    // no close app , just in background
    print("Main Dart show this  >  message notification !!! no close app , just in background");

//    print(message.data.toString());
//    print(message.notification!.title);

    LocalNotificationService.display(message);

  }else{

    print("xxxx - message notification is null !!!");

  }


}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  // no close app , just in background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);




//
//  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//    print('A new onMessageOpenedApp event was published!');
//    RemoteNotification? notification = message.notification;
//    AndroidNotification? android = message.notification?.android;
//    print("print body !");
//    print(message.notification!.body);
//    LocalNotificationService.display(message);
//
////        final routerFromMessage = message.data["router"];
////        print(routerFromMessage);
////        Navigator.of(context).pushNamed(routerFromMessage);
//
//
//  });


//  await flutterLocalNotificationsPlugin
//      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//      ?.createNotificationChannel(channel);

//  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//    alert: true,
//    badge: true,
//    sound: true,
//  );
  runApp(
      EasyLocalization(
          supportedLocales: [Locale('en'), Locale('zh'), Locale('ms')],
          path: 'assets/translations', // <-- change the path of the translation files
          fallbackLocale: Locale('en'),
          child: (LoginUiApp())
      ),

  );


}


class LoginUiApp extends StatelessWidget {

  final _scaffoldKey = GlobalKey();
//  const MyApp({Key? key}) : super(key: key);
  Color _primaryColor = HexColor("#DC54FE");
  Color _accentColor = HexColor("#8A02AE");
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Image headImage = Image.asset("assets/images/bill_detail_photos.png");
    precacheImage(headImage.image, context);

    return MaterialApp(


      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Login ',
      theme: ThemeData(
        primaryColor: _primaryColor,
        accentColor: _accentColor,
        scaffoldBackgroundColor:  Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home:  SplashScreen(title: 'Raxic'),
      key: _scaffoldKey,
      routes: {
        'billapp' : (_) => BillingPage(),

      },
    );
  }
}




//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
//      body: Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            const Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.headline4,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: const Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }

