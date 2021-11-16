import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/network/general_post_http.dart';
import 'package:http/http.dart' as http;


List<unpaiditems> itemFromJson(String str) => List<unpaiditems>.from(json.decode(str).map((x) => unpaiditems.fromJson(x)));


class unpaiditems{



  String? bi_id;
  String? bi_term;
  String? bi_termname;
  String? bi_termtype;
  String? bi_termamount;
  String? bi_totalamount;
  String? bi_startdate;
  String? bi_status;

//  unpaiditems();


  unpaiditems.fromJson(Map<String,dynamic> json){
    this.bi_id = json['bi_id'];
    this.bi_term = json['bi_term'];
    this.bi_termname = json['bi_termname'];
    this.bi_termtype = json['bi_termtype'];
    this.bi_termamount = json['bi_termamount'];
    this.bi_totalamount = json['bi_totalamount'];
    this.bi_startdate = json['bi_startdate'];
    this.bi_status = json['bi_status'];

  }


}



//List<processItems> possitems = [
////  processItems("001", "11/11/2021", "99.99", "TermName", "COD","15.00","12",1),
////  processItems("002", "11/11/2021", "99.99", "TermName", "COD","15.00","12",2),
////  processItems("003", "11/11/2021", "99.99", "TermName", "COD","15.00","12",1),
////  processItems("004", "11/11/2021", "99.99", "TermName", "COD","15.00","12",3),
////  processItems("005", "11/11/2021", "99.99", "TermName", "COD","15.00","12",2),
////];


Future<List<unpaiditems>?> getUnpaidList(String userID) async {

  List<unpaiditems> processItems_ = [] ;

  print(userID);


  Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/dashboard.php");
  var data_post = {
    "getUnpaidBill" : "tokenkey",
    "getUnpaidBill_accountID" : base64.encode(utf8.encode(userID)).toString(),
  };

  var data = await http.post(url,body:data_post);

  if(data.statusCode == 200){

    if(data.body != "" && data.body != "noRecord"){

      var JsonData = json.decode(data.body);
      if(JsonData != "noRecord"){

        print(JsonData);
        for (var ma in JsonData) {

          try {


            unpaiditems m = unpaiditems.fromJson(ma);
            print(m.bi_id);
            processItems_.add(m);

          } catch (e) {
            print(e.toString() + " < is json");
          }
//        items.add( billingData.fromJson(ma) );
        }


      }



      return processItems_;


    }




  }else{

    return processItems_;

  }



}

