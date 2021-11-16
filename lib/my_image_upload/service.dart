

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/global_setting.dart';
import 'package:flutter_app/model/billing_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class ImageService {


  static Future<dynamic> uploadFile(filePath , billingData bditems , BuildContext cntxt  ) async{

    var authToken = "";
    var _userId = "";
    double indcateValue = 0;

    try{

      SharedPreferences pref = await SharedPreferences.getInstance();
      _userId = pref.getString("user_id")!;


      var extension = p.extension(filePath);

      FormData formdata = FormData.fromMap(
          {
            "file": await MultipartFile.fromFile(filePath,filename: '${_userId.toString()}_${bditems.bi_id}_${DateTime.now().millisecondsSinceEpoch}_${ GlobalUserInfomation.GenerateFileName(6)}.$extension'),
            "accountID" : _userId.toString(),
            "bill_id" : bditems.bi_id,
            "apr_bill_gbl" : bditems.gbl_id,
            "apr_bill_type" : bditems.bi_category,
            "apr_termtype" : bditems.bi_termtype,
            "apr_totalamt" : bditems.bi_totalamount,
            "apr_termamt" : bditems.bi_termamount,
          }

          );


      Response response = await Dio().post(
        "https://xeroxlinks.com/mypos/apps/payment_upload.php",
        data: formdata,
        onSendProgress: (int send , int total) {

          indcateValue = (send / total);
          print("$send / $total");
        }
      );

      return response;


    }on DioError catch(e){
      print("Failed Servie!!!");
        return e.response;

    } catch(e){
      print("error service.darth");
    }



  }



}