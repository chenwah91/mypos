
import 'dart:convert';
import 'package:easy_localization/src/public_ext.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/pages/customerdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/network/general_post_http.dart';

import '../profile_page.dart';

class userinfoform extends StatefulWidget {
  @override
  _userinfoformState createState() => _userinfoformState();
}

class _userinfoformState extends State<userinfoform> {

  CustomerData? csdata;
  String? MyuserId;
  String DataProcessText = "Data Updating...".tr();
  String DataProcessText2 = "Please waiting....".tr();

  void initState(){
    super.initState();

    getCustomerDetail();


  }

  Future<void> getCustomerDetail() async {

    SharedPreferences sharepref = await SharedPreferences.getInstance();
    var ax = await sharepref.getString("user_data");

    csdata = CustomerData.fromJson(jsonDecode(ax!));
    setState(() {

      ctr_u_username.text = csdata!.u_username;
      ctr_ca_email.text = csdata!.ca_email;
      ctr_adr1.text = csdata!.ca_address1;
      ctr_adr2.text = csdata!.ca_address2;
      ctr_pcode.text = csdata!.ca_pos;
      ctr_city.text = csdata!.ca_city;
      ctr_state.text = csdata!.ca_state;
      ctr_country.text = csdata!.ca_country;
      ctr_phone.text = csdata!.ca_phone;

      MyuserId = csdata!.user_id;

      lastupdateText = "last update :".tr() + "${csdata!.u_lastupdate}";


    });

  }

  TextEditingController ctr_u_username = TextEditingController() ,
      ctr_ca_email = TextEditingController() ,
      ctr_adr1 = TextEditingController() ,
      ctr_adr2 = TextEditingController() ,
      ctr_pcode = TextEditingController(),
      ctr_city = TextEditingController() ,
      ctr_state = TextEditingController() ,
      ctr_country = TextEditingController(),
      ctr_phone = TextEditingController();

  bool isSubmitNewUpdate = false;
  bool isUpdateCompleted = false;
  String lastupdateText = "last update :".tr();

  final _globalFormKey = GlobalKey<FormState>();



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
      supportedLocales: [Locale('en'), Locale('zh'), Locale('ms')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: null,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll){
        overScroll.disallowIndicator();
        return true;

      }, child: Container(
          child: Column(
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
                              "Update Infomation".tr(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54),
                            )),
                      ),

                    ],
                  )),
              Expanded(
                child: Container(

                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Container(

                            padding: EdgeInsets.only(left: 20,right: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Form(
                              key: _globalFormKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("User Name".tr(),style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                        controller: ctr_u_username,
                                        validator: (value){
                                          if(value!.isEmpty){
                                            return "User Name Cant Empty.".tr();
                                          }else if( value.length < 3){
                                            return "User Name Too Short".tr();
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'New User Name.'.tr(),
                                          contentPadding: EdgeInsets.all(10.0),
                                        ),
                                      ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("Email Account".tr(),style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),

                                    child: TextFormField(

                                      controller: ctr_ca_email,
                                      validator: (value){

                                        if (value!.isEmpty) {
                                          return 'Please enter a valid email address'.tr();
                                        }
                                        if (!value.contains('@')) {
                                          return 'Email is invalid, must contain @'.tr();
                                        }
                                        if (!value.contains('.')) {
                                          return 'Email is invalid, must contain .'.tr();
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'New Email'.tr(),
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),


                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("Contact".tr(),style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: ctr_phone,
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return 'input Cant Empty.'.tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'New Contact'.tr(),
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("Address 1",style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: ctr_adr1,
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return 'input Cant Empty.'.tr();
                                        }
                                        return null;
                                      },
                                      maxLines: null,
                                      minLines: 4,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'New Address 1'.tr(),
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("Address 2".tr(),style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: ctr_adr2,
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return 'input Cant Empty.'.tr();
                                        }
                                        return null;
                                      },
                                      maxLines: null,
                                      minLines: 4,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'New Address 2'.tr(),
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("Pos Code".tr(),style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: ctr_pcode,
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return 'input Cant Empty.'.tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'New Pos Code'.tr(),
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("City".tr(),style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: ctr_city,
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return 'input Cant Empty.'.tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'New City'.tr(),
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                    ),
                                  ),


                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("State".tr(),style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: ctr_state,
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return 'input Cant Empty.'.tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'New State'.tr(),
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("Country".tr(),style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: ctr_country,
                                      validator: (value){
                                        if (value!.isEmpty) {
                                          return 'input Cant Empty.'.tr();
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'New Country'.tr(),
                                        contentPadding: EdgeInsets.all(10.0),

                                      ),

                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                ],
                              ),
                            ),
                          ),
                         Container(
                           padding: EdgeInsets.only(left: 25,bottom: 35),
                           alignment: Alignment.topLeft,
                           child: Column(
                             children: [
                               Text("${ lastupdateText.toUpperCase() }",style: TextStyle(fontSize: 13,color: Colors.grey),)
                             ],
                           ),
                         )

                        ],
                      ),
                    ),

                  ),
                ),
              ),
            ],
          ),
        ) ),
        floatingActionButton: FloatingActionButton(
          
          onPressed: () async {

            print("is pressed");


            setState(() {
              isSubmitNewUpdate = true;
            });


            if(_globalFormKey.currentState!.validate() && MyuserId != null){


              print("is pressed2");

              BuildContext dialogContext = context;

              showDialog(context: context,barrierDismissible: false ,  builder: (context){
                dialogContext = context;
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
                          isUpdateCompleted == true ? ( Icon(Icons.check_circle , size: 70,color: Colors.green,) ): SizedBox(),
                          isUpdateCompleted == true ?   SizedBox(height: 15,) : SizedBox(),
                          Text("$DataProcessText",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text("$DataProcessText2",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                        ],
                      ),
                    ),
                  ),
                );
              });



              Map<String , String > data = {
                "updateUserDataToken" : "tokenkey",
                "updateUserDataToken_user_id" : MyuserId.toString(),
                "u_username" : ctr_u_username.text,
                "ca_email" : ctr_ca_email.text,
                "ca_address1" : ctr_adr1.text,
                "ca_address2" : ctr_adr2.text,
                "ca_pos" : ctr_pcode.text,
                "ca_city" : ctr_city.text,
                "ca_state" : ctr_state.text,
                "ca_country" : ctr_country.text,
                "ca_phone" : ctr_phone.text,
              };

              String res = await rfunction().GeneralPostReturn("https://xeroxlinks.com/mypos/apps/userdata.php", data);

              print(res);
              if(res == "success") {
                Navigator.pop(dialogContext);


                setState(() {

                  isUpdateCompleted = true;
                  isSubmitNewUpdate = false;
                  DataProcessText2 = "";
                  DataProcessText = "Update Completed".tr();

                });


                SharedPreferences sharepref = await SharedPreferences.getInstance();
                String? user_id = await sharepref.getString("user_id");
                String? user_password = await sharepref.getString("user_password");


                var xdata = {
                  "getUserData_psw" : user_password.toString() ,
                  "getUserData_id" : user_id.toString(),
                  "getUserDataToken" : user_id.toString() ,
                };

                dynamic resx = await rfunction().GeneralPostReturn("https://xeroxlinks.com/mypos/apps/userdata.php",xdata);

                Map<String, dynamic> userData = (resx);

                print(resx);
                var user = CustomerData.fromJson(userData);
                GlobalUserInfomation.setPrefUserData(user);


                showDialog(context: context,  builder: (context){
                  dialogContext = context;
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
                            isUpdateCompleted == true ? ( Icon(Icons.check_circle , size: 70,color: Colors.green,) ): SizedBox(),
                            isUpdateCompleted == true ?   SizedBox(height: 15,) : SizedBox(),
                            Text("$DataProcessText",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Text("$DataProcessText2",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                          ],
                        ),
                      ),
                    ),
                  );
                });




              }else{

                Navigator.pop(dialogContext);

                setState(() {
                  isSubmitNewUpdate = false;
                  isUpdateCompleted = false;
                  DataProcessText2 = "Please try again.".tr();
                  DataProcessText = "Update Failed".tr();
                });


                showDialog(context: context ,  builder: (context){
                  dialogContext = context;
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
                            isUpdateCompleted == true ? ( Icon(Icons.check_circle , size: 70,color: Colors.green,) ): SizedBox(),
                            isUpdateCompleted == true ?   SizedBox(height: 15,) : SizedBox(),
                            Text("$DataProcessText",style: TextStyle(fontSize: 15 , color: Colors.grey , fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Text("$DataProcessText2",style: TextStyle(fontSize: 12 , color: Colors.grey),)

                          ],
                        ),
                      ),
                    ),
                  );
                });




              }

            }else{

              setState(() {
                isSubmitNewUpdate = false;
              });


            }

          },
          tooltip: 'Submit'.tr(),
          child: isSubmitNewUpdate == false ? Icon(Icons.save) : SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: Colors.white,strokeWidth: 2,)),
        ),
      ),
    );
  }
}
