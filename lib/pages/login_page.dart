
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/subpages/create_account.dart';
import 'package:flutter_app/service/fcm_cui.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/common/theme_helper.dart';
import 'package:flutter_app/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customer.dart';
import 'customerdata.dart';
import 'forgot_password_page.dart';
import 'widgets/header_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:easy_localization/src/public_ext.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}):super(key:key);
  
  @override
  _loginPageState createState() => _loginPageState();
  

}



class _loginPageState extends State<LoginPage> {



  double _headerHeight = 100;
  Key _formKey = GlobalKey<FormState>();
  bool loginValid = false;
  bool processing = false;

  final loginaccctrl = TextEditingController();
  final passwordctrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    checkLogin();
  }

  void checkLogin() async{

    SharedPreferences sharepref = await SharedPreferences.getInstance();
    String? val = await sharepref.getString("user_id");

    if(val != null){


      FirebaseMessaging.instance.getToken().then((value){

        fcm_cui.RegisterAndUpdateFCMtoken(val , value!);

      });


//      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage()));
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Homepage("to_Dashboarh")), (route) => false);

    }

  }

  void customerSignIn() async{

    setState(() {
      processing = true;
    });


    if(loginaccctrl.text == ""){

//      Fluttertoast.showToast(msg: 'Login ID cant null',toastLength: Toast.LENGTH_SHORT);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Enter Your Username."),backgroundColor: Colors.redAccent,));
      setState(() {
        processing = false;
      });
      return null;
    }

    if(passwordctrl.text == ""){

//      Fluttertoast.showToast(msg: 'Password cant null',toastLength: Toast.LENGTH_SHORT);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Enter Your Password."),backgroundColor: Colors.redAccent,));
      setState(() {
        processing = false;
      });
      return null;
    }


    var url = Uri.parse("https://xeroxlinks.com/mypos/apps/apps_login.php");
    var data = {
      "login_acc" : loginaccctrl.text,
      "login_password" : passwordctrl.text,
    };

    var res = await http.post(url,body:data);
    if(jsonDecode(res.body) == "nofound"){

//      Fluttertoast.showToast(msg: 'Account no found',toastLength: Toast.LENGTH_SHORT);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Account no found").tr(),backgroundColor: Colors.redAccent,));
    }else {
      if( jsonDecode(res.body) == "false" ){

        //Fluttertoast.showToast(msg: 'Password Incorrect',toastLength: Toast.LENGTH_SHORT);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Password Incorrect").tr(),backgroundColor: Colors.redAccent,));

      }else{

        print(jsonDecode(res.body));
        Map<String, dynamic> userData = jsonDecode(res.body);
        var user = CustomerData.fromJson(userData);
        print("UserID ${user.user_id} -> userEmail ${user.ca_email}");

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("user_id",user.user_id);
        await pref.setString("user_email",user.ca_email);
        await pref.setString("user_password",passwordctrl.text);

        GlobalUserInfomation.setPrefUserData(user);


        FirebaseMessaging.instance.getToken().then((value){

          fcm_cui.RegisterAndUpdateFCMtoken(user.user_id , value!);

        });




        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Homepage("to_Dashboarh")));

      }
    }

    setState(() {
      processing = false;
    });

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeArea(child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child:Column(
                    children: [
//                  Text('Hello', style: TextStyle(fontSize: 60,fontWeight: FontWeight.bold),),
                      SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset("assets/images/myposlogo4_663259_icon.png")
                      ),
                      Text('Signin into your account'.tr(), style: TextStyle(fontWeight: FontWeight.normal),),
                      SizedBox(height: 30.0,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextField(
                              controller:loginaccctrl,
                              decoration: ThemeHelper().textInputDecoration("User Name".tr() , "Enter your user name".tr()),

                            ),
                            SizedBox(height: 30.0),
                            TextField(
                                controller: passwordctrl,
                                obscureText: true,
                                decoration: ThemeHelper().textInputDecoration("Password".tr(),"Enter your Password".tr())
//                        InputDecoration(labelText: 'Password', hintText: 'Enter your Password',fillColor: Colors.white,filled: true),

                            ),
                            SizedBox(height: 5),
                            Container(
                              margin: EdgeInsets.fromLTRB(10,10,10,20),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  onTap: () async {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));


                                  },
                                  child: Text("Forget your password?").tr()
                              ),
                            ),
                            SizedBox(height: 25,),
                            Container(
//                                decoration: ThemeHelper().buttonBoxDecoration(context),

                                child: ElevatedButton(
//                                  style: ThemeHelper().buttonStyle(),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                                  foregroundColor: MaterialStateProperty.all(Colors.red),
                                  elevation: MaterialStateProperty.all(1),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.deepPurple)
                                        )
                                    )
                                ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(40, 10, 40 , 10),
                                    child: processing == false ? Text("Sign In".tr().toUpperCase(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),) : CircularProgressIndicator(backgroundColor: Colors.blue,)
                                    ,
                                  ),
                                  onPressed: (){

                                    customerSignIn();

                                  }  ,
                                )
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10,20,10,20),

                              child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>createcustomeraccount()));
                                  },
                                  child: Text("Don\'t have an account? Create").tr()
                              ),
                            )
                          ],

                        ),
                      )
                    ],
                  )
              )),
            ],
          ),
        )
      ),

    );


 

  }

  checkInputAndValidate() {

    return false;
    
  }




  loginSuccess() {

    print("....  x  ");

  }



}
