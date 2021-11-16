
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/common/theme_helper.dart';

import 'forgot_password_verification_page.dart';
import 'login_page.dart';
import 'widgets/header_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {

  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailaddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.password_rounded),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Forgot Password?',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ).tr(),
                            SizedBox(height: 10,),
                            Text('Enter the email address associated with your account.',
                              style: TextStyle(
                                  // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ).tr(),
                            SizedBox(height: 10,),
                            Text('We will email you a verification code to check your authenticity.',
                              style: TextStyle(
                                color: Colors.black38,
                                // fontSize: 20,
                              ),
                              // textAlign: TextAlign.center,
                            ).tr(),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                controller: _emailaddress ,
                                decoration: ThemeHelper().textInputDecoration("Email", "Enter your email"),
                                validator: (val){
                                  if(val!.isEmpty){
                                    return "Email can't be empty".tr();
                                  }
                                  else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      40, 10, 40, 10),
                                  child: Text(
                                    "Send".tr().toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if(_formKey.currentState!.validate()) {


                                    String verification = GlobalUserInfomation.GenerateDigit(4);


                                    var formData2 = FormData.fromMap({
                                      "recoveryPassword":"token",
                                      "recovery_email": base64.encode(utf8.encode(_emailaddress.text)).toString() ,
                                      "recoveryCode": base64.encode(utf8.encode(verification)).toString() ,

                                    });


                                    print("LoginPage v=> ${verification}");
                                    print("LoginPage v=> ${base64.encode(utf8.encode(verification)).toString()}");

                                    var dio = Dio();

                                    var resp =  await dio.post('https://xeroxlinks.com/mypos/myemail/forgetpassword.php', data:formData2 ).then((value){


                                      print("value ${jsonDecode(value.data)}");

                                      var mydata = jsonDecode(value.data);
                                      print("rESULT : > ${ mydata['resp']}");

                                      if(mydata.containsKey("resp")){

                                          if(mydata['resp'] == "done"){

                                            Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ForgotPasswordVerificationPage( varificationCode: verification, vrf_email: _emailaddress.text, )),
                                          );

                                          }

                                      }

//
//



                                    }).catchError((onError){
                                      print("error >  ${onError.toString()}");


                                    });












                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 30.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "Remember your password?".tr()),
                                  TextSpan(
                                    text: 'Login'.tr(),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {

                                        Navigator.pop(context);

                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}