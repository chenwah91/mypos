
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/customerdata.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/splash_screen.dart';
import 'package:flutter_app/pages/subpages/update_userinfo.dart';
import 'package:flutter_app/pages/widgets/header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'forgot_password_page.dart';
import 'forgot_password_verification_page.dart';
import 'registration_page.dart';

import 'dart:convert';

class ProfilePage extends StatefulWidget{

  final String ActionStr;

  const ProfilePage({Key? key, required this.ActionStr, }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  double  _drawerIconSize = 24;
  double _drawerFontSize = 17;

  CustomerData? csdata ;

  void initState() {

    super.initState();

    getCustomerDetail();

    if(widget.ActionStr == "UserDetail_openDetail"){

      Navigator.push(context, MaterialPageRoute(builder: (context) => userinfoform())).then((value){

        getCustomerDetail();
        setState(() {

        });
      });

    }


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              }
          )
      ),
      home: Scaffold(
        key: _scaffoldkey,
        appBar: null

//      AppBar(
////        leading: IconButton(onPressed: ()=>_scaffoldkey.currentState?.openDrawer(), icon: const Icon(Icons.widgets)),
//        title: Text("Profile Page",
//          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//        ),
//        elevation: 0.5,
//        iconTheme: IconThemeData(color: Colors.white),
//        flexibleSpace:Container(
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//                  begin: Alignment.topLeft,
//                  end: Alignment.bottomRight,
//                  colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).accentColor,]
//              )
//          ),
//        ),
//        actions: [
//          Container(
//            margin: EdgeInsets.only( top: 16, right: 16,),
//            child: Stack(
//              children: <Widget>[
//                Icon(Icons.notifications),
//                Positioned(
//                  right: 0,
//                  child: Container(
//                    padding: EdgeInsets.all(1),
//                    decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
//                    constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
//                    child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
//                  ),
//                )
//              ],
//            ),
//          ),
//
//
//        ],
//      )
      ,

        body: SingleChildScrollView(
          child: Stack(
            children: [

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
//                  Container(
//                    padding: EdgeInsets.all(10),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(100),
//                      border: Border.all(width: 5, color: Colors.white),
//                      color: Colors.white,
//                      boxShadow: [
//                        BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
//                      ],
//                    ),
//                    child: Icon(Icons.person, size: 80, color: Colors.grey.shade300,),
//                  ),
                    SizedBox(height: 150,),
                    (csdata?.u_username == null && csdata?.u_username == "" ) ? Text('${csdata?.ca_name.toString()}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),) : Text('${csdata?.u_username.toString()}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),

                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "User Information".tr(),
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Card(
                            child: Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      ...ListTile.divideTiles(
                                        color: Colors.grey,
                                        tiles: [
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical:10),
                                            leading: Icon(Icons.my_location),
                                            title: Text("Address").tr(),
                                            subtitle: Text(
                                                "${csdata?.ca_address1} , ${csdata?.ca_address2} \n${csdata?.ca_pos} \n${ csdata?.ca_state  } / ${csdata?.ca_city} / ${csdata?.ca_country} ",),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.email),
                                            title: Text("Email").tr(),
                                            subtitle: Text("${csdata?.ca_email}"),
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.phone),
                                            title: Text("Phone").tr(),
                                            subtitle: Text("${csdata?.ca_phone}"),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                             width: MediaQuery.of(context).size.width,
                           padding: EdgeInsets.only(left: 5,right: 5),

                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)),
                                color: Colors.blue,
                                onPressed: (){

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => userinfoform())).then((value){

                                    getCustomerDetail();
                                    setState(() {

                                    });
                                  });

                                },
                                child: Text("Change Detail".tr(),style: TextStyle(color: Colors.white),)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getCustomerDetail() async {

    SharedPreferences sharepref = await SharedPreferences.getInstance();
    var ax = await sharepref.getString("user_data");
    csdata = CustomerData.fromJson(jsonDecode(ax!));
    setState(() {

    });

  }

}