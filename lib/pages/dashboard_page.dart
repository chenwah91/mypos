import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/billing_item.dart';
import 'package:flutter_app/pages/subpages/bill_detail.dart';
import 'package:flutter_app/pages/subpages/paiditems.dart';
import 'package:flutter_app/pages/subpages/processitens.dart';
import 'package:flutter_app/pages/subpages/unpaiditems.dart';
import 'package:flutter_app/service/push_notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


import '../main.dart';

 class DashboardPage extends StatefulWidget {
   @override
   _DashboardPageState createState() => _DashboardPageState();
 }

 class _DashboardPageState extends State<DashboardPage> {

   String? _Token ;
   int _counter = 0;
   String? UserID;
   String totalOutStanding = "0.00";
   String currentdate = "-";

   @override
   void initState() {
     super.initState();


     FirebaseMessaging.onMessage.listen((RemoteMessage message) {

       RemoteNotification? notification = message.notification;
       AndroidNotification? android = message.notification?.android;

       LocalNotificationService.display(message);


//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher',
//               ),
//             ));
//       }
     });

     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
       print('A new onMessageOpenedApp event was published!');
       RemoteNotification? notification = message.notification;
       AndroidNotification? android = message.notification?.android;


       if (notification != null && android != null) {

         final routerFromMessage = message.data["route"];

         Navigator.of(context).pushNamed(routerFromMessage);

//         showDialog(
//             context: context,
//             builder: (_) {
//               return AlertDialog(
//                 title: Text(notification.title!),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [Text(notification.body!)],
//                   ),
//                 ),
//               );
//             });
//


       }




     });


      runFirstSetup();


   }


   List<processItems>? myProcessingItems_ = [];
   List<paiditems>? myPaidItems_ = [];
   List<unpaiditems>? myUnPaidItems_  = [];


   Future<void> runFirstSetup() async {

     SharedPreferences pref = await SharedPreferences.getInstance();
     setState(() {
       UserID = pref.getString("user_id")!;
       _selctMargin = 12;

     });


     if(UserID == null){

       totalOutStanding ="-";

       setState(() {

       });

     }else{

       myProcessingItems_ = await getProcessList(UserID!);
       myPaidItems_ = await getpaidList(UserID!);
       myUnPaidItems_ = await getUnpaidList(UserID!);

       Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/dashboard.php");
       var data_post = {
         "getTotalOutstandingBalance" : "tokenkey",
         "getTotalOutstandingBalance_accountID" : base64.encode(utf8.encode(UserID!)).toString(),
       };

       var data = await http.post(url,body:data_post);

       if(data.statusCode == 200) {

         if (data.body != "" ) {


           totalOutStanding = "${jsonDecode(data.body)}";

           var now = new DateTime.now();
           var formatter = new DateFormat('yyyy-MM-dd');
           String formattedDate = formatter.format(now);


           currentdate = formattedDate;


         }else{

           totalOutStanding = "0.00";

         }
         setState(() {

         });


       }


     }





   }

   void showNotification() {

     FirebaseMessaging.instance.subscribeToTopic("myfirstTopic");
     setState(() {
       _counter++;


     });


//     LocalNotificationService.display(message);
//




  var mesg = [];
  mesg.add("title 01");
  mesg.add("description 01");
  mesg.add("billapp");
  LocalNotificationService.displayX(mesg);

//     flutterLocalNotificationsPlugin.show(
//         _counter,
//         "Testing $_counter",
//         "How you doin ?",
//         NotificationDetails(
//             android: AndroidNotificationDetails("mypos_chan"mypos_channel",
//                 importance: Importance.high,
//                 color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher')));


   }


   int _currentSelection = 1;
   double _selectorPositionX = 16.0;
   double _selectorWidth = 30;
   double _selctMargin = 12;
   Color _selectColor = Colors.red;

   GlobalKey _key1 = GlobalKey();
   GlobalKey _key2 = GlobalKey();
   GlobalKey _key3 = GlobalKey();


   _selectedItem(int id){

     print("int id = $id");

     GlobalKey? selectedglobleKey = _key1;
     _currentSelection = id;
     _selctMargin = 0;

     switch(id){
       case 1 : selectedglobleKey = _key1; _selectorWidth = 30; _selectColor = Colors.red; break;
       case 2 : selectedglobleKey = _key2; _selectorWidth = 30; _selectColor = Colors.orange; break;
       case 3 : selectedglobleKey = _key3; _selectorWidth = 30; _selectColor = Colors.green; break;
       default: selectedglobleKey = _key1; _selectorWidth = 30;_selectColor = Colors.red; break;
     }

     _setWidegetPositionX(selectedglobleKey);
     setState(() {

     });




   }

   _setWidegetPositionX(GlobalKey selectedKey){
     final RenderBox? widgetRenderBox = selectedKey.currentContext?.findRenderObject() as RenderBox;
     final widgetPosition = widgetRenderBox?.localToGlobal(Offset.zero);
     final widgetSize = widgetRenderBox?.size;

     double? wp_dx = widgetPosition?.dx;
     double minustarget = ((30.0-widgetSize!.width)/2);
     _selectorPositionX = ( wp_dx! - minustarget) ;

   }




   @override
   Widget build(BuildContext context) {
     return MaterialApp(

       home: Scaffold(
         appBar: null,
         body:  NotificationListener<OverscrollIndicatorNotification>(
         onNotification: (overScroll){
       overScroll.disallowIndicator();
       return true;

     },
     child: SafeArea(
           child: Container(
             margin: EdgeInsets.only(top: 10),
             width: MediaQuery.of(context).size.width,
             child: Column(
               children: [
                 Container(
                   padding: EdgeInsets.only(top: 15,left: 20,bottom: 10),
                    alignment: Alignment.topLeft,
                     child: Text("DashBoard",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black54),textAlign: TextAlign.left,)
                 ),
                 Container(
                   
                   
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(25),
                       gradient: LinearGradient(
                         stops: [
                           0.10,
                           0.91,
                         ],
                         begin: Alignment.centerLeft,
                         end: Alignment.centerRight,
                         colors: [
                           Color(0xFF36d1d6),
                           Color(0xFF5b86e5),
                         ],
                       )
                   ),


                   child: Container(

                     width:  MediaQuery.of(context).size.width-35,
                     height: 120,
                     alignment: Alignment.center,


                     child: Column(

                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [

                         Container(



                           alignment: Alignment.center,
                           child: Column(
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [

                                   Text("$totalOutStanding",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.white),),

                                 ],
                               ),
                               SizedBox(height: 8,),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text("Total Outstanding Balance.",style: TextStyle(fontSize: 17,color: Colors.white),)

                                 ],
                               ),
                               SizedBox(height: 5,),
                               Text("Last update : $currentdate".toUpperCase(),style: TextStyle(fontSize: 12,color: Colors.white),),

                             ],
                           ),
                         )

                       ],
                     ),

                   ),
                 ),

                 SizedBox(height: 15,),
                 Container(
                   child:  Stack(
                     children: [
                       Container(
                         padding:  EdgeInsets.only(top: 15,left: 5,bottom: 5),
                         margin: const EdgeInsets.only(left: 16,bottom: 12),
                         child: Row(
                           children: [
                             InkWell(
                               key: _key1,
                               onTap :(){
                                 _selectedItem(1);
                               },
                               child : Text("Unpaid",style: TextStyle(color: _currentSelection == 1 ?Colors.red : Colors.black),),
                             ),
                             SizedBox(width: 15,),
                             InkWell(
                               key: _key2,
                               onTap :(){
                                 _selectedItem(2);
                               },
                               child : Text("InProcess",style: TextStyle(color: _currentSelection == 2 ?Colors.orange : Colors.black),),
                             ),
                             SizedBox(width: 15,),
                             InkWell(
                               key: _key3,
                               onTap :(){
                                 _selectedItem(3);
                               },
                               child : Text("Paid Record",style: TextStyle(color: _currentSelection == 3 ?Colors.green : Colors.black),),
                             ),


                           ],
                         ),
                       ),
                       AnimatedPositioned(
                         duration: const Duration(milliseconds: 500),
                         curve: Curves.fastOutSlowIn,
                         left: _selectorPositionX,
                         bottom: 6,
                         child: Container(
                           margin: EdgeInsets.only(left: _selctMargin),
                           width: _selectorWidth,
                           height: 3,
                           decoration: ShapeDecoration(
                             shape: StadiumBorder(),
                             color: _selectColor,
                           ),
                         ),
                       )
                     ],
                   ),
                 ),
                 SizedBox(height: 5,),
                 Expanded(child: Container(

                   child:ListView(
                     children: [

                        SelItemBuild(),
                     ],
                   ),


                 ))


               ],





             ),
           ),
         )

       ),
     ));
   }


  Widget SelItemBuild(){

    switch(_currentSelection){

      case 1 : return ItemListUnpaid( unpaidCategory: selectorList(1)); break;
      case 2 : return ItemListProcess( unpaidCategory: selectorList(2)); break;
      case 3 : return ItemListPaid( unpaidCategory: selectorList(3)); break;
      default: return ItemListUnpaid( unpaidCategory: selectorList(1)); break;

    }



   }


   List<dynamic> selectorList(int ints){
//      == 2 ?  myProcessingItems_?.toList() as List<processItems> : [];


     switch(ints){
      case 1 : return (myUnPaidItems_  != []) ? myUnPaidItems_?.toList() as List<unpaiditems> : [] ; break;
      case 2 : return (myProcessingItems_  != []) ? myProcessingItems_?.toList() as List<processItems> : []  ; break;
      case 3 : return (myPaidItems_ != []) ? myPaidItems_?.toList() as List<paiditems> : []  ; break;
      default: return (myUnPaidItems_  != []) ? myUnPaidItems_?.toList() as List<unpaiditems> : [] ;break;
    }

   }


 }

 class noRowWidget extends StatelessWidget{
  const noRowWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width-30,
      padding: EdgeInsets.all(25),
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[200],
      ),

      child: Text("No Records.",style: TextStyle(fontSize: 15,color: Colors.grey),),

    );

  }

 }



class ItemListPaid extends StatelessWidget {

  final List<dynamic>  unpaidCategory;
  const ItemListPaid({ Key? key, required this.unpaidCategory }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: (!unpaidCategory.isEmpty) ? unpaidCategory.map((e) => ItemCardPaid(upaidItems: e)).toList() : [ noRowWidget() ]
    );
  }
}


class ItemCardPaid extends StatelessWidget {

  final paiditems upaidItems;
  const ItemCardPaid({Key? key, required this.upaidItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () async {


          SharedPreferences pref = await SharedPreferences.getInstance();
          String myUserID = await pref.getString("user_id")!;

          print("myuserid = > $myUserID");
          print("myuserid = > ${upaidItems.apr_billid!}");

          Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/dashboard.php");
          var data_post = {
            "getSingleBillDataToken" : "tokenkey",
            "getSingleBillDataToken_accountID" : base64.encode(utf8.encode(myUserID)).toString(),
            "getSingleBillDataToken_billId" : base64.encode(utf8.encode(upaidItems.apr_billid!)).toString(),
          };

          var data = await http.post(url,body:data_post);

          if(data.statusCode == 200){

            if(data.body == "no_data" ) {


              showDialog(context: context,   builder: (context){

                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Container(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ( Icon(Icons.cancel , size: 70,color: Colors.red,) ),
                          SizedBox(height: 10,),
                          Text("Unable to load Invoice",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("Please Try Again",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                        ],
                      ),
                    ),
                  ),
                );
              });



            }else{

              var JsonData = json.decode(data.body);

              try{
                print(JsonData.toString());

                billingData m = billingData.fromJson(JsonData);
                Navigator.push(context,CupertinoPageRoute(builder: (context)=>bill_detail(key: UniqueKey(), headtitle: "", selectedItems_: m)));


              }catch(e){
                print(e.toString() + " < is error");
              }




//              for (var ma in JsonData) {
//                //items.add(billingData.fromJson(JsonData));
//                try {
////            billingData m = billingData(
////                ma["bi_id"], ma["bi_category"], ma["bi_totalamount"]);
////            print(ma);
//
//
//
//                } catch (e) {
//                  print(e.toString() + " < is json");
//                }
////        items.add( billingData.fromJson(ma) );
//              }



            }



          }else{

            showDialog(context: context,   builder: (context){

              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ( Icon(Icons.cancel , size: 70,color: Colors.red,) ),
                        SizedBox(height: 10,),
                        Text("Unable to connect server...",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text("Please Try Again",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                      ],
                    ),
                  ),
                ),
              );
            });


          }



        },
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(


                width: MediaQuery.of(context).size.width-60,
                height: 120,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 15,left: 10),
                        child: Column(

                          children: [
//                          Icon(FontAwesomeIcons.dotCircle,color: Colors.orangeAccent,),
                            Row(
                              children: [
                                Text("Paid ",style:TextStyle(color: Colors.green,fontWeight: FontWeight.w500),),
                                Text("Invoice # ${upaidItems.apr_billid}"),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("Submit Date",style:TextStyle(fontSize: 10,color: Colors.grey),),
                            SizedBox(height: 2,),
                            Text("${upaidItems.apr_paydate}"),
                            SizedBox(height: 5,),
                            Text("Comfirm Date",style:TextStyle(fontSize: 10,color: Colors.grey),),
                            SizedBox(height: 2,),
                            Text("${(upaidItems.apr_approved_date == null)?"-": upaidItems.apr_approved_date}"),
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 15,right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            Padding(

                              padding: const EdgeInsets.only(top: 0,bottom: 5 ,right: 0),
                              child: Icon(Icons.check_circle,size: 35,color: Colors.green, ),
                            ),

                            Text((upaidItems.apr_termtype == "loan") ?  "${double.parse(upaidItems.apr_termamt!).toStringAsFixed(2)}":"${double.parse(upaidItems.apr_totalamt!).toStringAsFixed(2)}",style:TextStyle(fontSize: 25,color: Colors.black),),
                            SizedBox(height: 5,),
                            Text("Paid ${(upaidItems.apr_termtype == "loan") ? "Term" : ""} Amount",style:TextStyle(fontSize: 10,color: Colors.grey),),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  }
}


class ItemListUnpaid extends StatelessWidget {

  final List<dynamic>  unpaidCategory;
  const ItemListUnpaid({ Key? key, required this.unpaidCategory }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: (!unpaidCategory.isEmpty) ? unpaidCategory.map((e) => ItemCardUnpaid(upaidItems: e)).toList() : [ noRowWidget() ]
    );
  }
}


class ItemCardUnpaid extends StatelessWidget {

  final unpaiditems upaidItems;
  const ItemCardUnpaid({Key? key, required this.upaidItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () async {


          SharedPreferences pref = await SharedPreferences.getInstance();
          String myUserID = await pref.getString("user_id")!;

          print("myuserid = > $myUserID");
          print("myuserid = > ${upaidItems.bi_id!}");

          Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/dashboard.php");
          var data_post = {
            "getSingleBillDataToken" : "tokenkey",
            "getSingleBillDataToken_accountID" : base64.encode(utf8.encode(myUserID)).toString(),
            "getSingleBillDataToken_billId" : base64.encode(utf8.encode(upaidItems.bi_id!)).toString(),
          };

          var data = await http.post(url,body:data_post);

          if(data.statusCode == 200){

            if(data.body == "no_data" ) {


              showDialog(context: context,   builder: (context){

                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Container(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ( Icon(Icons.cancel , size: 70,color: Colors.red,) ),
                          SizedBox(height: 10,),
                          Text("Unable to load Invoice",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("Please Try Again",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                        ],
                      ),
                    ),
                  ),
                );
              });



            }else{

              var JsonData = json.decode(data.body);

              try{
                print(JsonData.toString());

                billingData m = billingData.fromJson(JsonData);
                Navigator.push(context,CupertinoPageRoute(builder: (context)=>bill_detail(key: UniqueKey(), headtitle: "", selectedItems_: m)));


              }catch(e){
                print(e.toString() + " < is error");
              }




//              for (var ma in JsonData) {
//                //items.add(billingData.fromJson(JsonData));
//                try {
////            billingData m = billingData(
////                ma["bi_id"], ma["bi_category"], ma["bi_totalamount"]);
////            print(ma);
//
//
//
//                } catch (e) {
//                  print(e.toString() + " < is json");
//                }
////        items.add( billingData.fromJson(ma) );
//              }



            }



          }else{

            showDialog(context: context,   builder: (context){

              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ( Icon(Icons.cancel , size: 70,color: Colors.red,) ),
                        SizedBox(height: 10,),
                        Text("Unable to connect server...",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text("Please Try Again",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                      ],
                    ),
                  ),
                ),
              );
            });


          }



        },
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(


                width: MediaQuery.of(context).size.width-60,
                height: 80,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 15,left: 10),
                        child: Column(

                          children: [
//                          Icon(FontAwesomeIcons.dotCircle,color: Colors.orangeAccent,),
                            Row(
                              children: [
                                Text("Unpaid ",style:TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w500),),
                                Text("Invoice # ${upaidItems.bi_id}"),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("Due Date",style:TextStyle(fontSize: 10,color: Colors.grey),),
                            SizedBox(height: 2,),
                            Text("${DateFormat('yyyy-MM-dd').format(DateTime.parse(upaidItems.bi_startdate!))}"),
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 15,right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(( upaidItems.bi_termtype == "loan" ) ? "${double.parse(upaidItems.bi_termamount!).toStringAsFixed(2) }" :"${double.parse(upaidItems.bi_totalamount!).toStringAsFixed(2) }",style:TextStyle(fontSize: 25,color: Colors.black),),
                            SizedBox(height: 5,),
                            Text("Outstanding Balance",style:TextStyle(fontSize: 10,color: Colors.grey),),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  }
}

class ItemListProcess extends StatelessWidget {

   final List<dynamic>  unpaidCategory;
   const ItemListProcess({ Key? key, required this.unpaidCategory }):super(key: key);

   @override
   Widget build(BuildContext context) {
     return Column(
       children: (!unpaidCategory.isEmpty) ? unpaidCategory.map((e) => ItemCardProcess(upaidItems: e)).toList() : [ noRowWidget() ]
     );
   }
 }
 
 class ItemCardProcess extends StatelessWidget {
   
   final processItems upaidItems;
   const ItemCardProcess({Key? key, required this.upaidItems}) : super(key: key);
   
   @override
   Widget build(BuildContext context) {
     return
       GestureDetector(
         onTap: () async {


           SharedPreferences pref = await SharedPreferences.getInstance();
           String myUserID = await pref.getString("user_id")!;

           print("myuserid = > $myUserID");
           print("myuserid = > ${upaidItems.apr_billid!}");

           Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/dashboard.php");
           var data_post = {
             "getSingleBillDataToken" : "tokenkey",
             "getSingleBillDataToken_accountID" : base64.encode(utf8.encode(myUserID)).toString(),
             "getSingleBillDataToken_billId" : base64.encode(utf8.encode(upaidItems.apr_billid!)).toString(),
           };

           var data = await http.post(url,body:data_post);

           if(data.statusCode == 200){

             if(data.body == "no_data" ) {


               showDialog(context: context,   builder: (context){

                 return Dialog(
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.all(Radius.circular(20))
                   ),
                   child: Container(
                     height: 200,
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           ( Icon(Icons.cancel , size: 70,color: Colors.red,) ),
                           SizedBox(height: 10,),
                           Text("Unable to load Invoice",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                           SizedBox(height: 10,),
                           Text("Please Try Again",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                         ],
                       ),
                     ),
                   ),
                 );
               });



             }else{

               var JsonData = json.decode(data.body);

               try{
                 print(JsonData.toString());

                 billingData m = billingData.fromJson(JsonData);
                 Navigator.push(context,CupertinoPageRoute(builder: (context)=>bill_detail(key: UniqueKey(), headtitle: "", selectedItems_: m)));


               }catch(e){
                 print(e.toString() + " < is error");
               }




//              for (var ma in JsonData) {
//                //items.add(billingData.fromJson(JsonData));
//                try {
////            billingData m = billingData(
////                ma["bi_id"], ma["bi_category"], ma["bi_totalamount"]);
////            print(ma);
//
//
//
//                } catch (e) {
//                  print(e.toString() + " < is json");
//                }
////        items.add( billingData.fromJson(ma) );
//              }



             }



           }else{

             showDialog(context: context,   builder: (context){

               return Dialog(
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.all(Radius.circular(20))
                 ),
                 child: Container(
                   height: 200,
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         ( Icon(Icons.cancel , size: 70,color: Colors.red,) ),
                         SizedBox(height: 10,),
                         Text("Unable to connect server...",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                         SizedBox(height: 10,),
                         Text("Please Try Again",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                       ],
                     ),
                   ),
                 ),
               );
             });

           }

         },
         child: Card(
         elevation: 1,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10.0),
           ),
         margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(


               width: MediaQuery.of(context).size.width-60,
               height: 80,
               child: Container(
                 alignment: Alignment.topCenter,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 15,left: 10),
                        child: Column(

                          children: [
//                          Icon(FontAwesomeIcons.dotCircle,color: Colors.orangeAccent,),
                            Row(
                              children: [
                                Text("Pay To ",style:TextStyle(color: Colors.orange,fontWeight: FontWeight.w500),),
                                Text("Invoice # ${upaidItems.apr_billid}"),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("Submit Date",style:TextStyle(fontSize: 10,color: Colors.grey),),
                            SizedBox(height: 2,),
                            Text("${upaidItems.apr_paydate}"),
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),

                      ),
                     Container(
                       padding: EdgeInsets.only(bottom: 15,right: 10),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.end,
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           Text((upaidItems.apr_termtype == "loan") ?  "${double.parse(upaidItems.apr_termamt!).toStringAsFixed(2)}":"${double.parse(upaidItems.apr_totalamt!).toStringAsFixed(2)}",style:TextStyle(fontSize: 25,color: Colors.black),),
                           SizedBox(height: 5,),
                           Text("Payment ${(upaidItems.apr_termtype == "loan") ? "Term" : ""} Amount",style:TextStyle(fontSize: 10,color: Colors.grey),),
                         ],
                       ),
                     )

                   ],
                 ),
               ),
             )
           ],
         ),
     ),
       );

   }
 }
 
 