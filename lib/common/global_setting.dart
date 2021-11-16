
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_app/pages/customerdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';



class GlobalUserInfomation {

  String dfDomain = "xeroxlinks.com";
  String dfDomain_secondPath = "mypos";

  Future<String>  getDomainPdfUrl() async {

    String defaulValOfDatabaseUrl = "$dfDomain/$dfDomain_secondPath/view/";

    SharedPreferences sharepref = await SharedPreferences.getInstance();
    String? val = await sharepref.getString("setting_domain_pdf_url");

    if(val != null){

      return val ;

    }else{

      await sharepref.setString("setting_domain_pdf_url",defaulValOfDatabaseUrl);
      return defaulValOfDatabaseUrl;

    }


  }


  static String GenerateFileName (int number){

//    var id = nanoid();

    return customAlphabet("123456789zxcvbnmaksldjfhgytieoqpqwertyuioplkasjdhfgcvxbznm",number);

  }


  static String GenerateDigit (int number){

//    var id = nanoid();
    var rng = new Random();
    String numb = "";
    for (var i = 0; i < number; i++) {
      numb = numb + rng.nextInt(9).toString();
    }
     
    return numb.padLeft(4,"0");

  }


  static setPrefUserData( CustomerData csdata ) async {

    SharedPreferences pref = await SharedPreferences.getInstance();


    await pref.setString("u_username",csdata.u_username);
    await pref.setString("ca_phone",csdata.ca_phone);
    await pref.setString("ca_name",csdata.ca_name);
    await pref.setString("ca_address1",csdata.ca_address1);
    await pref.setString("ca_address2",csdata.ca_address2);
    await pref.setString("ca_pos",csdata.ca_pos);
    await pref.setString("ca_city",csdata.ca_city);
    await pref.setString("ca_state",csdata.ca_state);
    await pref.setString("ca_country",csdata.ca_country);
    await pref.setString("u_lastupdate",csdata.u_lastupdate);
    await pref.setString("ca_status",csdata.ca_status);
    await pref.setString("u_loginid",csdata.u_loginid);
    await pref.setString("user_id",csdata.user_id);
    await pref.setString("user_email",csdata.ca_email);

    Map<String,dynamic> customerMap = csdata.toMap();

    print("global setting ${json.encode(customerMap)}");



    await pref.setString('user_data', json.encode(customerMap));


  }



}