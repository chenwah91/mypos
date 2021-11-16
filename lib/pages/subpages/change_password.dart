
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/pages/customerdata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: library_prefixes
import 'package:get/get_connect/http/src/response/response.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/network/general_post_http.dart';

import 'package:easy_localization/src/public_ext.dart';
import 'package:easy_localization/easy_localization.dart';


class changepassword extends StatefulWidget {
  @override
  _changepasswordState createState() => _changepasswordState();


}

class _changepasswordState extends State<changepassword> {

  String? userId;
  TextEditingController oldPassword = TextEditingController() , newPassword = TextEditingController();

  bool oldpassword_Visible  = false , newpassword_Visible = false;

  void initState(){
    super.initState();

    getUserInfo();
    oldpassword_Visible = true;
    newpassword_Visible = true;

  }

  final _globalFormKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: null,
      body:  NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll){
          overScroll.disallowIndicator();
          return true;

        },  
          child: SafeArea(
            
        child: Container(
          child: SingleChildScrollView(

            child: Container(
              height: MediaQuery.of(context).size.height,
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
                                  "Change Password".tr(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black54),
                                )),
                          ),

                        ],
                      )),
                    SizedBox(height: 15,),

                    Expanded(
                      child: Container(

                        alignment: Alignment.centerLeft,
                        child: Column(

                          children: [
                           Form(
                             child: Container(
                               alignment: Alignment.centerLeft,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children: [

                                   Padding(
                                     padding: EdgeInsets.only(left: 20,bottom: 15,top: 5),
                                     child: Text("Old Password".tr(),style: TextStyle(fontSize: 22),),
                                   ),

                                   Padding(
                                     padding: const EdgeInsets.only(left: 20,bottom: 15,top: 5 , right: 20),
                                     child: TextFormField(
                                       controller: oldPassword,
                                       obscureText: oldpassword_Visible,

                                       validator: (value){
                                         if(value!.isEmpty){
                                           return "Old Password Cant Empty.".tr();
                                         }
                                         return null;
                                       },
                                       decoration: InputDecoration(

                                         border: OutlineInputBorder(),
                                         hintText: 'Old Password'.tr(),
                                         contentPadding: EdgeInsets.all(10.0),
                                           suffixIcon: Padding(
                                             padding: const EdgeInsets.all(4.0),
                                             child: IconButton(
                                               splashColor: Colors.transparent,
                                               icon: Icon(oldpassword_Visible == true ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,size: 15,),

                                               onPressed: (){


                                                 oldpassword_Visible = !oldpassword_Visible;
                                                 setState(() {
                                                 });

                                               },
                                             ),
                                           )
                                       ),
                                     ),
                                   ),

                                   Padding(
                                     padding: EdgeInsets.only(left: 20,bottom: 15,top: 5),
                                     child: Text("New Password".tr(),style: TextStyle(fontSize: 22),),
                                   ),

                                   Padding(
                                     padding: const EdgeInsets.only(left: 20,bottom: 15,top: 5 , right: 20),
                                     child: TextFormField(
                                       controller: newPassword,
                                       obscureText: newpassword_Visible,
                                       validator: (value){
                                         if(value!.isEmpty){
                                           return "New Password Cant Empty.".tr();
                                         }else if( value.length < 6){
                                           return "Password Length must more then 6 digit or alphanumeric.".tr();
                                         }
                                         return null;
                                       },
                                       decoration: InputDecoration(
                                         border: OutlineInputBorder(),
                                         hintText: 'New Password'.tr(),
                                         contentPadding: EdgeInsets.all(10.0),
                                         suffixIcon: Padding(
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


                                 ],
                               ),
                             ),
                             key: _globalFormKey,
                             autovalidateMode: AutovalidateMode.onUserInteraction,
                           ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 15),

                                padding: EdgeInsets.only(left: 20,right: 20),
                                alignment: Alignment.center,
                                child:FlatButton(
                                    height: 60,
                                    minWidth: MediaQuery.of(context).size.width,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    color: Colors.lightBlueAccent,
                                    textColor: Colors.white,
                                    onPressed: () async {

                                      if(_globalFormKey.currentState!.validate() && userId != null){


                                        var dio = Dio();

//                                print(userId.toString());
//                                print(oldPassword.text);
//                                print(newPassword.text);
//                                print(base64.encode(utf8.encode(userId.toString())));

                                        var formData = FormData.fromMap({
                                          "updatePasswordToken":"token",
                                          "updatePasswordToken_user_id": base64.encode(utf8.encode(userId.toString())).toString() ,
                                          "updatePasswordToken_oldpassword": base64.encode(utf8.encode(oldPassword.text)).toString() ,
                                          "updatePasswordToken_newpassword": base64.encode(utf8.encode(newPassword.text)).toString() ,
                                        });

                                        var response = await dio.post('https://xeroxlinks.com/mypos/apps/updatepassword.php', data:formData );
                                        if(response.statusCode == 200){

                                          if(jsonDecode(response.data)  == 'passwordIncorrect'){

                                            showDialog(context: context,  builder: (context){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Container(
                                                  height: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Password Incorrect".tr(),style: TextStyle(fontSize: 15 , color: Colors.red , fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 10,),
                                                        Text("Please try again".tr(),style: TextStyle(fontSize: 12 , color: Colors.redAccent),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });


                                          }else if( jsonDecode(response.data) == "updateFailed"){

                                            showDialog(context: context,  builder: (context){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Container(
                                                  height: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Failed To Update".tr(),style: TextStyle(fontSize: 15 , color: Colors.red , fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 10,),
                                                        Text("Please try again".tr(),style: TextStyle(fontSize: 12 , color: Colors.redAccent),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });

                                          }else if(jsonDecode(response.data) == "noUserFound"){


                                            showDialog(context: context,  builder: (context){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Container(
                                                  height: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Failed To Update ( Account No Found )".tr(),style: TextStyle(fontSize: 15 , color: Colors.red , fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 10,),
                                                        Text("Please try again".tr(),style: TextStyle(fontSize: 12 , color: Colors.redAccent),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });


                                          }else if(jsonDecode(response.data) == "param_no_match"){


                                            showDialog(context: context,  builder: (context){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Container(
                                                  height: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Failed To Update".tr(),style: TextStyle(fontSize: 15 , color: Colors.red , fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 10,),
                                                        Text("Please try again".tr(),style: TextStyle(fontSize: 12 , color: Colors.redAccent),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });


                                          }else if(jsonDecode(response.data) == "Success"){

                                            showDialog(context: context,  builder: (context){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Container(
                                                  height: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Update Success".tr(),style: TextStyle(fontSize: 15 , color: Colors.green , fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 10,),
                                                        Text("Your password has been updated.".tr(),style: TextStyle(fontSize: 12 , color: Colors.green),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });

                                            SharedPreferences pref = await SharedPreferences.getInstance();
                                            await pref.setString("user_password",newPassword.text);
                                            setState(() {

                                            });



                                            print(pref.getString("user_password"));

                                          }else{

                                            showDialog(context: context,  builder: (context){
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Container(
                                                  height: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Unknow Error".tr(),style: TextStyle(fontSize: 15 , color: Colors.red , fontWeight: FontWeight.bold),),
                                                        SizedBox(height: 10,),
                                                        Text("Please try again".tr(),style: TextStyle(fontSize: 12 , color: Colors.redAccent),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });


                                          }




                                        }else{


                                          showDialog(context: context,  builder: (context){
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(20))
                                              ),
                                              child: Container(
                                                height: 100,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text("Update failed".tr(),style: TextStyle(fontSize: 15 , color: Colors.red , fontWeight: FontWeight.bold),),
                                                      SizedBox(height: 10,),
                                                      Text("Please try again".tr(),style: TextStyle(fontSize: 12 , color: Colors.redAccent),)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });


                                          print("update failed");


                                        }


                                      }


//                                if(jsonDecode(response.data) == "nofound"){
//
//                                }


                                    },
                                    child:Text("Update Password".tr().toUpperCase()) )
                            )



                          ],
                        ),
                      ),

                    )





                ],
              ),
            ),
          ),

        ),



      )),
    );




  }

  Future<void> getUserInfo() async {

    SharedPreferences sharepref = await SharedPreferences.getInstance();
    userId = await sharepref.getString("user_id");

    setState(() {

    });

    print("userid = $userId");



  }
}
