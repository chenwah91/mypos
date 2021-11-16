
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/dashboard_page.dart';
import 'package:flutter_app/pages/product_page.dart';
import 'package:flutter_app/pages/profile_page.dart';
import 'package:flutter_app/pages/setting_page.dart';
import 'package:flutter_app/pages/testPulltoRef.dart';
import 'package:flutter_app/service/push_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import 'billing_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class Homepage extends StatelessWidget{
  Homepage(this.ActionStr);
  final String ActionStr;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyPackage(key: UniqueKey(), stringAction: ActionStr,),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      routes: {
        'billapp' : (_) => BillingPage(),
      },
    );
  }
}

 class MyPackage extends StatefulWidget {

    final String stringAction ;
    const MyPackage({required Key key, required this.stringAction}):super(key: key);

   @override
   _MyPackageState createState() => _MyPackageState();
 }
 
 class _MyPackageState extends State<MyPackage> {




   int _counter = 0;

    
//    late String userId ;
//
//    void getCred() async{
//
//      SharedPreferences pref = await SharedPreferences.getInstance();
//
//      setState(() {
//        userId = pref.getString("user_id")!;
//      });
//
//    }
    
    
    var appBarTitleText = new Text("MyPos");
    int currentIndex = 0;




  final List<String> _titleText = [
    "Home".tr(),
    "Product".tr(),
    "Billing".tr(),
    "Profile".tr(),
    "Setting".tr(),
  ];



   Future<void> setPermis() async {


     FirebaseMessaging messaging = FirebaseMessaging.instance;

     NotificationSettings settings = await messaging.requestPermission(
       alert: true,
       announcement: false,
       badge: true,
       carPlay: false,
       criticalAlert: false,
       provisional: false,
       sound: true,
     );

     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
       print('User granted permission');
     } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
       print('User granted provisional permission');
     } else {
       print('User declined or has not accepted permission');
     }

   }

   @override
   void initState() {
     super.initState();


     if(widget.stringAction.contains("UserDetail")){

       currentIndex = 3;
       appBarTitleText = Text(_titleText[currentIndex]);

     }


     FirebaseMessaging.instance.getInitialMessage().then((message){


       if(message != null){

         LocalNotificationService.display(message);

         final routerFromMessage = message.data["router"];
         final openBillFromMessage = message.data["openbill"];

         print("onmessage home_pages >  $routerFromMessage");

         if(routerFromMessage == "billapp"){

           if(openBillFromMessage != ""){

           }

           setState((){

             currentIndex = 2;
             appBarTitleText = Text(_titleText[currentIndex]);


           });


         }

       }

     });



     setPermis();
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//       LocalNotificationService.display(message);
//
////       if (notification != null && android != null) {
////         flutterLocalNotificationsPlugin.show(
////             notification.hashCode,
////             notification.title,
////             notification.body,
////             NotificationDetails(
////               android: AndroidNotificationDetails(
////                 channel.id,
////                 channel.name,
////                 color: Colors.blue,
////                 playSound: true,
////                 icon: '@mipmap/ic_launcher',
////               ),
////             ));
////       }
////
//
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//
//
//       final routerFromMessage = message.data["router"];
//       final openBillFromMessage = message.data["openbill"];
//
//       print("onmessage home_pages >  $routerFromMessage");
//
//       if(routerFromMessage == "billapp"){
//
//         if(openBillFromMessage != ""){
//
//
//
//         }
//
//         setState((){
//
//           currentIndex = 2;
//           appBarTitleText = Text(_titleText[currentIndex]);
//
//
//         });
//
//
//       }
//
////       Navigator.of(context).pushNamed(routerFromMessage);
//
//
//
//
////       if (notification != null && android != null) {
////         showDialog(
////             context: context,
////             builder: (_) {
////               return AlertDialog(
////                 title: Text(notification.title!),
////                 content: SingleChildScrollView(
////                   child: Column(
////                     crossAxisAlignment: CrossAxisAlignment.start,
////                     children: [Text(notification.body!)],
////                   ),
////                 ),
////               );
////             });
////       }
//
//
//
//
//     });



   }
     void showNotification() {
      setState(() {
        _counter++;
      });


      flutterLocalNotificationsPlugin.show(
          _counter,
          "Testing $_counter",
          "How you doin ?",
          NotificationDetails(
              android: AndroidNotificationDetails("mypos_channel", "mypos_channel",
                  importance: Importance.high,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher')));



    }


   @override
   Widget build(BuildContext context) {

     List<Widget> _children = [

       DashboardPage(),
       ProviderScope(child: ProductPage()),
       BillingPage(),
       ProfilePage( ActionStr: widget.stringAction ,),
       SettingPage()

     ];

     SystemChrome.setEnabledSystemUIOverlays([]);
     
     return Scaffold(

         resizeToAvoidBottomInset: false,

       appBar:null,
       body: _children[currentIndex] ,
       bottomNavigationBar: Container(
         child:  BottomNavyBar(
            containerHeight: 65,
           showElevation: true,
           itemCornerRadius: 40,

           selectedIndex: currentIndex,
           onItemSelected: (index){
             setState((){
               currentIndex = index;
               appBarTitleText = Text(_titleText[currentIndex]);
             });

           },
           items: <BottomNavyBarItem>[
             BottomNavyBarItem(
               icon: Icon(Icons.home,),
               title: Text("Home".tr(),textAlign: TextAlign.center,),
               activeColor: Colors.blueAccent,
               inactiveColor: Colors.black,

             ), BottomNavyBarItem(
               icon: Icon(Icons.shopping_cart),
               title: Text("Product".tr(),textAlign: TextAlign.center,),
               activeColor: Colors.blueAccent,
               inactiveColor: Colors.black,
             ), BottomNavyBarItem(
               icon: Icon(Icons.payment),
               title: Text("Billing".tr(),textAlign: TextAlign.center,),
               activeColor: Colors.blueAccent,
               inactiveColor: Colors.black,
             ), BottomNavyBarItem(
               icon: Icon(Icons.account_circle),
               title: Text("Account".tr(),textAlign: TextAlign.center,),
               activeColor: Colors.blueAccent,
               inactiveColor: Colors.black,
             ), BottomNavyBarItem(
               icon: Icon(Icons.settings),
               title: Text("Setting".tr(),textAlign: TextAlign.center,),
               activeColor: Colors.blueAccent,
               inactiveColor: Colors.black,
             ),
           ],
         ),
       )
     );
   }



 }
  

