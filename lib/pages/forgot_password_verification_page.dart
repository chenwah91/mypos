import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/common/theme_helper.dart';
import 'package:flutter_app/pages/customerdata.dart';
import 'package:flutter_app/pages/subpages/bill_detail.dart';
import 'package:flutter_app/pages/widgets/countdown_verification.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'forgot_password_update.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'widgets/header_widget.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'widgets/countdown_verification.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class ForgotPasswordVerificationPage extends StatefulWidget {
  final String varificationCode;
  final String vrf_email;
  const ForgotPasswordVerificationPage({Key? key, required this.varificationCode, required this.vrf_email}) : super(key: key);

  @override
  _ForgotPasswordVerificationPageState createState() => _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState extends State<ForgotPasswordVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final otpkey_ = GlobalKey();

  String? _currentVarificationCode;

  bool _pinSuccess = false;
  bool _countIsEnd = false;
  bool isFinishCountdown = false;
  bool reached = true;


  void initState(){

    super.initState();
    alert = DateTime.now().add(Duration(seconds: 20));
    setState(() {
      _currentVarificationCode = widget.varificationCode;
    });
    startTimer();

  }

  Timer? _timer;
  int _start = 20;

  void startTimer() {

    print("st : $_start");


    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {

        if (_start == 0) {
          setState(() {
            timer.cancel();
            reached = true;
          });
        } else {
          print(_start);
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  late DateTime alert;

  String formatDuration(Duration d) {
    String f(int n) {
      return n.toString().padLeft(2, '0');
    }
    // We want to round up the remaining time to the nearest second
    d += Duration(microseconds: 999999);

    if("${f(d.inMinutes)}:${f(d.inSeconds % 60)}" == "00:01"){
        print("endup next sec");
        reached = true;
    }
    print("$reached");
    return "${f(d.inMinutes)}:${f(d.inSeconds % 60)}";
  }



  @override
  Widget build(BuildContext context) {
    double _headerHeight = 150;


    return Scaffold(

        backgroundColor: Colors.white,
        body: SingleChildScrollView(

          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(
                    _headerHeight, true, Icons.privacy_tip_outlined),
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
                            Text('Verification',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
                              ),
                              // textAlign: TextAlign.center,
                            ).tr(),
                            SizedBox(height: 10,),
                            Text(
                              'Enter the verification code we just sent you on your email address.',
                              style: TextStyle(
                                // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54
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
                            OTPTextField(
                              key: otpkey_,
                              length: 4,
                              width: 300,
                              fieldWidth: 50,
                              style: TextStyle(
                                  fontSize: 30
                              ),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onChanged: (pin){
                                print("Pin : $pin");
                              },
                              onCompleted: (pin) {

                                if(!reached){
                                  if(pin == _currentVarificationCode){

                                    print("success");
                                    setState(() {
                                      _pinSuccess = true;
                                    });

                                  }else{

                                    setState(() {
                                      _pinSuccess = false;
                                    });
                                    print("error");
                                  }

                                }else{

                                  print("Times Out");

                                }


                              },
                            ),
                            SizedBox(height: 50.0),

                            Container(

                              child:TimerBuilder.scheduled([alert], builder: (context) {
                                // This function will be called once the alert time is reached
                                var now = DateTime.now();
                                reached = now.compareTo(alert) >= 0;

                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[

                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              reached ? Icons.alarm_on : Icons.alarm,
                                              color: reached ? Colors.red : Colors.green,
                                              size: 15,
                                            ),
                                            SizedBox(width: 5,),
                                            !reached
                                                ? TimerBuilder.periodic(Duration(seconds: 1),
                                                alignment: Duration.zero, builder: (context) {
                                                  // This function will be called every second until the alert time
                                                  var now = DateTime.now();
                                                  var remaining = alert.difference(now);
                                                  return Text(
                                                    formatDuration(remaining),
                                                    style: TextStyle(fontSize: 15, color: Colors.green,letterSpacing: 1),
                                                  );
                                                })
                                                : Text(
                                              "00:00",
                                              style: TextStyle(fontSize: 15, color: Colors.red,letterSpacing: 1),
                                            ),

                                          ],
                                        ),
                                      ) ,

                                    ],
                                  ),
                                );
                              }),
                            ),

//                              child: SlideCountdown(
//                                key: _cdkey ,
//                                icon: Padding(
//                                  padding: const EdgeInsets.only(right:5,bottom: 2),
//                                  child: Icon(FontAwesomeIcons.clock , size: 15 ,color: Colors.white,),
//                                ),
//                                duration: const Duration(seconds: 6),
//                                onDone: (){
//                                  print("Is Done !!! ");
//
//                                },
//
//                              ),



                            SizedBox(height: 50.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "If you didn't receive a code!".tr(),
                                    style: TextStyle(
                                      color: Colors.black38,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Resend',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {

                                        _currentVarificationCode = GlobalUserInfomation.GenerateDigit(4);

                                        var formData2 = FormData.fromMap({
                                          "recoveryPassword":"token",
                                          "recovery_email": base64.encode(utf8.encode(widget.vrf_email)).toString() ,
                                          "recoveryCode": base64.encode(utf8.encode(_currentVarificationCode!)).toString() ,

                                        });


                                        print("fpvp v=> ${_currentVarificationCode}");
                                        print("fpvp v=> ${base64.encode(utf8.encode(_currentVarificationCode!)).toString()}");

                                        var dio = Dio();

                                        var resp =  await dio.post('https://xeroxlinks.com/mypos/myemail/forgetpassword.php', data:formData2 ).then((value){


                                          print("value ${jsonDecode(value.data)}");

                                          var mydata = jsonDecode(value.data);

                                          if(mydata.containsKey("resp")){

                                            if(mydata['resp'] == "done"){
                                              alert = DateTime.now().add(Duration(seconds: 20));
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ThemeHelper().alartDialog("Successful",
                                                      "Verification code resend successful.",
                                                      context);
                                                },
                                              );


                                              setState(() {

                                               reached = false;
                                               _start = 20;

                                              });
                                              startTimer();


                                            }

                                          }else{


                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ThemeHelper().alartDialog("Unsuccessful".tr(),
                                                    "Please try again.".tr(),
                                                    context);
                                              },
                                            ).then((value){
                                              Navigator.pop(context);
                                            });


                                          }





                                        }).catchError((onError){
                                          print("error >  ${onError.toString()}");


                                        });




                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: (reached ) ? ThemeHelper().buttonBoxDecoration(context, "#AAAAAA","#757575") : _pinSuccess ? ThemeHelper().buttonBoxDecoration(context):ThemeHelper().buttonBoxDecoration(context, "#AAAAAA","#757575"),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      40, 10, 40, 10),
                                  child: Text(
                                    reached ? "Try Again".tr() : "Verify".tr().toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed:  (reached ) ? (){

                                } : _pinSuccess ? () async {

                                  _start = 0;
                                  _timer?.cancel();

                                  setState(() {

                                  });



                                  var url = Uri.parse("https://xeroxlinks.com/mypos/apps/forgotpassword.php");
                                  var data = {
                                    "forgotpasswordtoken" : "token" ,
                                    "forgotpasswordtoken_email" : base64.encode(utf8.encode(widget.vrf_email)).toString()  ,

                                  };
                                  var res = await http.post(url,body:data);
                                  Map<String, dynamic> userData = jsonDecode(res.body);
                                  var user = CustomerData.fromJson(userData);
                                  GlobalUserInfomation.setPrefUserData(user);


                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => forgotpassword_update(fgps_oldPassword: user.forgot_passord, mycustomer: user, )
                                      ),
                                          (Route<dynamic> route) => false
                                  );
                                } : null,
                              ),
                            ),

//                            Container(
//                              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
//                              decoration: ThemeHelper().buttonBoxDecoration(context,"#AAAAAA","#757575"),
//                              child: ElevatedButton(
//                                style: ThemeHelper().buttonStyle(),
//                                child: Padding(
//                                  padding: const EdgeInsets.fromLTRB(
//                                      40, 10, 40, 10),
//                                  child: Text(
//                                    "Back".toUpperCase(),
//                                    style: TextStyle(
//                                      fontSize: 20,
//                                      fontWeight: FontWeight.bold,
//                                      color: Colors.white,
//                                    ),
//                                  ),
//                                ),
//                                onPressed: true ? () {
//                                  Navigator.of(context).pushAndRemoveUntil(
//                                      MaterialPageRoute(
//                                          builder: (context) => LoginPage()
//                                      ),
//                                          (Route<dynamic> route) => false
//                                  );
//                                } : null,
//                              ),
//                            )
                          ],
                        ),
                      ),

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
