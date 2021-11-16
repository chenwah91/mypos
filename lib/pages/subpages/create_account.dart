
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/service/fcm_cui.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';


import '../customerdata.dart';
import '../home_page.dart';

class createcustomeraccount extends StatefulWidget {
  @override
  _createcustomeraccountState createState() => _createcustomeraccountState();
}

class _createcustomeraccountState extends State<createcustomeraccount> {

  final _globalFormKey = GlobalKey<FormState>();


  TextEditingController _username = TextEditingController() , _phone = TextEditingController() , _password = TextEditingController() ,
      _email = TextEditingController() , _loginId = TextEditingController();

  bool setAutoValidate = false;
  bool newpassword_Visible = true;
  bool submitCA = false;

  bool ischeckLoginId = false;
  bool LoginIdIsAvailable = false;
  bool checkLoginDone = false;
  String checkloginIdResult = "failed";


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: null,
        body: SafeArea(
        child: Container(
        child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
    Container(
    padding: EdgeInsets.only(top: 10,left: 5),
    height: 60,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.only(left: 0, top: 0),
    child: Row(
    mainAxisAlignment:
    MainAxisAlignment.spaceBetween,
    children: [
    FlatButton(
    minWidth: 15,
    onPressed: ()
    async {
    Navigator.pop(context);
    },
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    child: Icon(
    Icons.arrow_back_ios,
    size: 20,
    )),
    Expanded(
    child: SizedBox(
//                                 child: Text("${ widget.headtitle } ", style: TextStyle(fontSize: 18), )
    child: Text(
    "Create Account",
    style: TextStyle(
    fontSize: 18,
    color: Colors.black54),
    ).tr()),
    ),

    ],
    )),
    SizedBox(height: 15,),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                child: Form(

//                  autovalidateMode: AutovalidateMode.onUserInteraction,
                autovalidateMode: setAutoValidate == true ? AutovalidateMode.always : null,
                  key: _globalFormKey,
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("User Name".tr(),style: TextStyle(fontSize: 18),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          controller: _username,
                          validator: (value){
                            if(value!.isEmpty){
                              return "User Name Cant Empty.".tr();
                            }else if( value.length < 4){
                              return "User Name Too Short".tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter User Name.'.tr(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Login ID".tr(),style: TextStyle(fontSize: 18),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          controller: _loginId,
                          onEditingComplete: () async {
                            setState(() {
                              ischeckLoginId = true;
                            });
                            var dio = Dio();

                            var formData = FormData.fromMap({
                              "checkAccountIsValid":"token",
                              "loginAcc": base64.encode(utf8.encode(_loginId.text.toString())).toString() ,
                            });

                            var response = await dio.post('https://xeroxlinks.com/mypos/apps/createcustomeraccount.php', data:formData ).then((value){


                              print(value.data);

                              setState(() {

                                checkloginIdResult = jsonDecode(value.data);
                                checkLoginDone = true;

                              });


                            }).catchError((onError){

                              setState(() {

                                checkloginIdResult = "failed";
                                checkLoginDone = false;

                              });


                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Can\'t Connect Server...".tr()),backgroundColor: Colors.redAccent,));

                            });





                            print(_loginId.text);

                          },
                          validator: (value){
                            if(value!.isEmpty){
                              return "Login ID Cant Empty.".tr();
                            }

                            if( value.length < 6){
                              return "Login ID Too Short".tr();
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Contact.'.tr(),
                              contentPadding: EdgeInsets.all(10.0),
                              suffixIcon:  ischeckLoginId == true ?
                              (checkLoginDone == true)?
                              (checkloginIdResult == "done") ?
                              Icon(FontAwesomeIcons.checkCircle,color: Colors.green,size: 20,) : Icon(FontAwesomeIcons.timesCircle,color: Colors.red,size: 2,)
                                  : Padding(
                                padding: const EdgeInsets.all(15.0),
                                child:  SizedBox( width: 5 , height: 5, child: CircularProgressIndicator( strokeWidth:  2,)) ,
                              ) : null
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Password",style: TextStyle(fontSize: 18),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          obscureText: newpassword_Visible,
                          controller: _password,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Password Cant Empty.".tr();
                            }

                            if( value.length < 6){
                              return "Password Too Short".tr();
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Contact.',
                            contentPadding: EdgeInsets.all(10.0),
                              suffixIcon:  Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  icon: Icon(newpassword_Visible == true ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,size: 15,),
                                  onPressed: (){
                                    newpassword_Visible = !newpassword_Visible;
                                    setState(() {
                                    });
                                  },
                                ),
                              )
                          ),
                        ),
                      ),






                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Email Account".tr(),style: TextStyle(fontSize: 18),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),

                        child: TextFormField(

                          controller: _email,
                          validator: (value){

                            if (value!.isEmpty) {
                              return 'Please enter a valid email address'.tr();
                            }else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value)){
                              return "Enter a valid email address".tr();
                            }


                            if (!value.contains('@')) {
                              return 'Email is invalid, must contain @'.tr();
                            }
                            if (!value.contains('.')) {
                              return 'Email is invalid, must contain.'.tr();
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Email'.tr(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),


                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Contact".tr(),style: TextStyle(fontSize: 18),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: TextFormField(
                          controller: _phone,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Contact Cant Empty.".tr();
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Contact.'.tr(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                      ),




                    ],


                  ),
                ),

              ),
            ),
          ),
          Container(

              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(25),
              alignment: Alignment.center,
              child:FlatButton(
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width-50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  color: Colors.lightBlueAccent,
                  textColor: Colors.white,
                  onPressed: () async {


                    if(checkloginIdResult != "done"){
                      await CheckLoginId();
                    }


                    if(_globalFormKey.currentState?.validate() == true && checkloginIdResult == "done"){

                      setState(() {
                        submitCA = true;
                      });

                      print("isTrueValidate");

                      var dio = Dio();

                      var formData2 = FormData.fromMap({
                        "createCustomerAccountToken":"token",
                        "createCustomerAccountToken_username": base64.encode(utf8.encode(_username.text.toString())).toString() ,
                        "createCustomerAccountTokenn_email": base64.encode(utf8.encode(_email.text)).toString() ,
                        "createCustomerAccountToken_password": base64.encode(utf8.encode(_password.text)).toString() ,
                        "createCustomerAccountToken_phone": base64.encode(utf8.encode(_phone.text)).toString() ,
                        "createCustomerAccountToken_loginid": base64.encode(utf8.encode(_loginId.text)).toString() ,
                      });

//                      print("input ->  ${base64.encode(utf8.encode(_username.text.toString())).toString() } ");
//                      print("input ->  ${base64.encode(utf8.encode(_email.text.toString())).toString() } ");
//                      print("input ->  ${base64.encode(utf8.encode(_password.text.toString())).toString() } ");
//                      print("input ->  ${base64.encode(utf8.encode(_phone.text.toString())).toString() } ");
//                      print("input ->  ${base64.encode(utf8.encode(_loginId.text.toString())).toString() } ");


                     var resp =  await dio.post('https://xeroxlinks.com/mypos/apps/createcustomeraccount.php', data:formData2 ).then((value)  async {

                        setState(() {
                          submitCA = false;
                        });



                        var mydata = jsonDecode(value.data);
                        print("rESULT : > ${ mydata['status']}");

                      if(mydata.containsKey("status")){


                        if(mydata['status'] == "done"){

                          SharedPreferences pref = await SharedPreferences.getInstance();
                          await pref.setString("user_id",mydata['uId']);
                          await pref.setString("user_email",mydata['uEmail']);
                          await pref.setString("user_password",_password.text);


                          String? user_id = await pref.getString("user_id");
                          String? user_password = await pref.getString("user_password");

                          if(user_id != null){

                            FirebaseMessaging.instance.getToken().then((value){

                            fcm_cui.RegisterAndUpdateFCMtoken(user_id , value!);

                            print("registerandyodarefcmtoken");

                           });


                        var url = Uri.parse("https://xeroxlinks.com/mypos/apps/userdata.php");
                        var data = {
                          "getUserData_psw" : user_password.toString() ,
                          "getUserData_id" : user_id.toString(),
                          "getUserDataToken" : user_id.toString() ,
                        };


                          var res = await http.post(url,body:data);

                        //user_id
                          var myUserData = jsonDecode(res.body);
                          if(myUserData.containsKey("user_id")) {

                            Map<String, dynamic> userData = jsonDecode(res.body);

                            var user = CustomerData.fromJson(userData);
                            GlobalUserInfomation.setPrefUserData(user);

                            showDialog(context: context,  builder: (context){
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

                                        Icon(Icons.check_circle , size: 50,color: Colors.green,),
                                        SizedBox(height: 12,),
                                        Text("Your Account has been create".tr(),style: TextStyle(fontSize: 15 , color: Colors.green , fontWeight: FontWeight.bold),),
                                        SizedBox(height: 5,),
                                        FlatButton(
                                      shape: RoundedRectangleBorder(
                                         side: BorderSide(
                                           color: Colors.green
                                         ),
                                        borderRadius: BorderRadius.circular(15),

                                      ),
                                            onPressed: (){

                                        Navigator.of(context).pushAndRemoveUntil( PageTransition(
                                              type: PageTransitionType.bottomToTop,
                                              child: Homepage("UserDetail_openDetail"),
                                              ),(router)=>false);


                                            }, child: Text("Go to Dashboard",style: TextStyle(color: Colors.green),)
                                        )

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).then((_){



                            print("here");


                            });


                          }

                        }




                       }



                      }





                      }).catchError((onError){

                        setState(() {
                          submitCA = false;
                        });
                        print("Catch 01 ${onError.toString()}");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Can\'t Connect Server...".tr()),backgroundColor: Colors.redAccent,));
                      });


//                      print("rESULT ->  ${(resp.data)} ");


                    }else{


                      setState(() {
                        setAutoValidate = true;
                        submitCA = false;
                      });
                      print("isFalseValidate");


                    }

                  },
                  child: submitCA == true ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,

                    ),
                  ) : Text("Create Account".tr().toUpperCase())
              )
          )
    ]
    )
    )
    )
    );



  }

  CheckLoginId() async {

    if(checkloginIdResult != "done"){

      var dio = Dio();

      var formData = FormData.fromMap({
        "checkAccountIsValid":"token",
        "loginAcc": base64.encode(utf8.encode(_loginId.text.toString())).toString() ,
      });

      var response = await dio.post('https://xeroxlinks.com/mypos/apps/createcustomeraccount.php', data:formData ).then((value){


        print(value.data);

        setState(() {

          checkloginIdResult = jsonDecode(value.data);
          checkLoginDone = true;

        });


      }).catchError((onError){

        setState(() {

          checkloginIdResult = "failed";
          checkLoginDone = false;

        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Can\'t Connect Server...".tr()),backgroundColor: Colors.redAccent,));

      });


    }

  }
}
