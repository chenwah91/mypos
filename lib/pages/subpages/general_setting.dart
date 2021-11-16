
import 'package:flutter/cupertino.dart';
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

class generalSetting extends StatefulWidget {
  @override
  _generalSettingState createState() => _generalSettingState();
}

class _generalSettingState extends State<generalSetting> {

  final _globalFormKey = GlobalKey<FormState>();
  TextEditingController server_website_ctr = TextEditingController() , server_path_ctr = TextEditingController();


  void initState(){

    super.initState();
    checkIsSetServer();

  }

  Future<void> checkIsSetServer() async {

    SharedPreferences pref = await SharedPreferences.getInstance();


    if(pref.containsKey("server_website")){

      server_website_ctr.text = await pref.getString("server_website")!;

    }else{

      await pref.setString("server_website", "https://xeroxlinks.com/");
      server_website_ctr.text = await pref.getString("server_website")!;

    }


    if(pref.containsKey("server_path")){

      server_path_ctr.text = await pref.getString("server_path")!;

    }else{

      await pref.setString("server_path", "mypos");
      server_path_ctr.text = await pref.getString("server_path")!;

    }



  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: null,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll)
          {
            overScroll.disallowIndicator();
            return true;
          },child: Container(
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
                              "",
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
                                    child: Text("Website Url",style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: server_website_ctr,

                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Website Url Cant Empty.";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Website Url',
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Text("Path",style: TextStyle(fontSize: 18),),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      controller: server_path_ctr,
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Path Cant Empty.";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Path',
                                        contentPadding: EdgeInsets.all(10.0),
                                      ),
                                    ),
                                  ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 20),
                                padding: EdgeInsets.only(left: 0,right: 0),
                                alignment: Alignment.center,
                                child:FlatButton(
                                  height: 50,
                                  minWidth: MediaQuery.of(context).size.width,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  color: Colors.lightBlueAccent,
                                  textColor: Colors.white,
                                  onPressed: () {

                                  },
                                    child:Text("Update".toUpperCase()) ),
                                )



                                ],


                              ),



                            )
                          )



                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),



        ),

        )



    );
  }
}

