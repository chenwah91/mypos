

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/forgot_password_verification_page.dart';
//ForgotPasswordVerificationPage

class countDownVrf extends StatefulWidget {

  countDownVrf(Key key):super(key: key);

  @override
  countDownVrfState createState() => countDownVrfState();
}

class countDownVrfState extends State<countDownVrf> {

  final keycd_ = GlobalKey();


  void initState(){
    super.initState();

  }

  void resetCountDown(){

    print("Is resetCountDown !!! ");
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {


    return SlideCountdown(
        key: keycd_,
                                icon: Padding(
                                  padding: const EdgeInsets.only(right:5,bottom: 2),
                                  child: Icon(FontAwesomeIcons.clock , size: 15 ,color: Colors.white,),
                                ),
                                duration: const Duration(seconds: 6),
                                onDone: (){

                                  print("Is Done !!! ");

                                },

                              );
  }



}
