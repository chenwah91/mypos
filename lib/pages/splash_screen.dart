import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/service/push_notification_service.dart';
import 'package:flutter_app/service/fcm_cui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'customerdata.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}



Route _createRouteHomepage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Homepage("to_Dashboarh"),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class SecondPageRoute extends CupertinoPageRoute {
  SecondPageRoute()
      : super( builder: (BuildContext context) => new LoginPage());


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new LoginPage());
  }
}



class _SplashScreenState extends State<SplashScreen> {

  bool _isVisible =false;

  bool isHaveLoginRecord = false;
  String loadingdisplayText = "";
  bool setLoading = false;


  @override
  void initState() {


    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

    checkLogin();

    print("splash screen initstate");
    LocalNotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message){

      if(message!=null){
        LocalNotificationService.display(message);

        ///        final routerFromMessage = message.data["router"];
////        print(routerFromMessage);
////        Navigator.of(context).pushNamed(routerFromMessage);

      }else{

        print("message is null");

      }






//      if(message != null){
//        final routerFromMessage = message.data["router"];
//        print("onmessage openedapp home_pages  $routerFromMessage");
//        Navigator.of(context).pushNamed(routerFromMessage);
//
//      }else{
//
//        print("onmessage splash screen initstate!");
//
//      }


    });

    FirebaseMessaging.instance.getToken().then((value){
      print("Token :::: > $value");
    });



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("splash screen onMessage");
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      final routerFromMessage = message.data["router"];

      print("onMessage >  $routerFromMessage");

       LocalNotificationService.display(message);

//      if (notification != null && android != null) {
//        flutterLocalNotificationsPlugin.show(
//            notification.hashCode,
//            notification.title,
//            notification.body,
//            NotificationDetails(
//              android: AndroidNotificationDetails(
//                channel.id,
//                channel.name,
//                color: Colors.blue,
//                playSound: true,
//                icon: '@mipmap/ic_launcher',
//              ),
//            ));
//      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
//         print("print body !");
//         print(message.notification!.body);
         LocalNotificationService.display(message);

//        final routerFromMessage = message.data["router"];
//        print(routerFromMessage);
//        Navigator.of(context).pushNamed(routerFromMessage);


    });




  }

  _SplashScreenState(){

    print('_SplashScreenState run first!');


    new Timer(
      Duration(milliseconds: 10),(){
        setState((){
          _isVisible = true;
        });
        }
    );

  }

  void checkLogin() async{

    SharedPreferences sharepref = await SharedPreferences.getInstance();
    String? user_id = await sharepref.getString("user_id");
    String? user_password = await sharepref.getString("user_password");

    if(user_id != null){

      FirebaseMessaging.instance.getToken().then((value){

        fcm_cui.RegisterAndUpdateFCMtoken(user_id , value!);

      });

      setState(() {
        isHaveLoginRecord = true;
      });

      setState((){
        setLoading = true;
        loadingdisplayText = "";
      });


//      new Timer(
//          Duration(milliseconds: 1500),(){
//          setState((){
//            setLoading = true;
//            loadingdisplayText = "";
//          });
//        }
//      );


      var url = Uri.parse("https://xeroxlinks.com/mypos/apps/userdata.php");
      var data = {
        "getUserData_psw" : user_password.toString() ,
        "getUserData_id" : user_id.toString(),
        "getUserDataToken" : user_id.toString() ,
      };


      var res = await http.post(url,body:data);

      print("<<RES>> ${res.body}" );

      if(jsonDecode(res.body) == "nofound") {

        print(jsonDecode(res.body));
        new Timer(
            Duration(milliseconds: 3000),(){
          Navigator.of(context).pushAndRemoveUntil( PageTransition(
            type: PageTransitionType.leftToRight,
            child: LoginPage(),
          ) , (router)=>false);

        }
        );



      }else if(jsonDecode(res.body) == "false"){

        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();

        new Timer(
          Duration(milliseconds: 3000),(){
          Navigator.of(context).pushAndRemoveUntil( PageTransition(
            type: PageTransitionType.leftToRight,
            child: LoginPage(),
          ) , (router)=>false);

        }
      );



        print(jsonDecode(res.body));

      }else if(jsonDecode(res.body) == ""){

        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();

        new Timer(
            Duration(milliseconds: 2000),(){
          Navigator.of(context).pushAndRemoveUntil( PageTransition(
            type: PageTransitionType.leftToRight,
            child: LoginPage(),
          ),(router)=>false);
        }
        );
        print(jsonDecode(res.body));


      }else{


        Map<String, dynamic> userData = jsonDecode(res.body);
        var customer = CustomerData.fromJson(userData);

        if(customer.user_id != user_id){

          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.clear();

//          Navigator.of(context).pushAndRemoveUntil(_createRouteHomepage(), (route) => false);


          new Timer(
              Duration(milliseconds: 2000),(){
            Navigator.of(context).pushAndRemoveUntil( PageTransition(
              type: PageTransitionType.leftToRight,
              child: LoginPage(),
            ),(router)=>false);
           }
          );


        }else{


          Map<String, dynamic> userData = jsonDecode(res.body);

          var user = CustomerData.fromJson(userData);
          GlobalUserInfomation.setPrefUserData(user);

          new Timer(
              Duration(milliseconds: 2000),(){
            Navigator.of(context).pushAndRemoveUntil( PageTransition(
              type: PageTransitionType.leftToRight,
              child: Homepage("to_Dashboarh"),
            ),(router)=>false);
          }
          );






        }

      }



//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
//      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Homepage()), (route) => false);
//      Navigator.of(context).pushAndRemoveUntil(_createRoute(),(router)=>false);




    }else{

       setState(() {
         isHaveLoginRecord = false;

       });


       new Timer(const Duration(milliseconds: 5000),(){

         Navigator.of(context).push( PageTransition(
           type: PageTransitionType.leftToRight,
           child: LoginPage(),
         ));


       });


    }

  }

  int _counter = 0;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: null,
      body: Container(
        decoration: new BoxDecoration(
//        gradient: new LinearGradient(colors: [
//          Theme.of(context).accentColor,
//          Theme.of(context).primaryColor],
//            begin: const FractionalOffset(0, 0) ,
//          end: const FractionalOffset(1.0, 0.0) ,
//          stops: [0.0,1.0],
//          tileMode: TileMode.clamp,
//        )
          color: Colors.white,
        ),

        width: MediaQuery.of(context).size.width,
        height:  MediaQuery.of(context).size.height,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0,
                    duration: Duration(milliseconds: 1200),
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 200,
                            width: 200,
                            child: Image.asset("assets/images/myposlogo4_663259_icon.png")
                        ),
                        setLoading ? CircularProgressIndicator(color: Colors.grey) : SizedBox(),
                        SizedBox(
                            height: 25,
                        ),
                         Text("$loadingdisplayText")


                      ],
                    ),
                  ),
                ),
              ),

              Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text("MyDestinyTechnolohy @ 2021",style: TextStyle(fontSize: 15,color: Colors.black54),),
              )
            ]
        ),
      ),
    );


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
//              '$_counter OLLB',
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






  }


}
