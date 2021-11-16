import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/network/general_post_http.dart';
import 'package:http/http.dart' as http;


List<processItems> itemFromJson(String str) => List<processItems>.from(json.decode(str).map((x) => processItems.fromJson(x)));


class processItems{

   String? apr_billid;
   String? apr_payerid;
   String? apr_bill_gbl;
   String? apr_bill_type;
   String? apr_totalamt;
   String? apr_termamt;
   String? apr_paydate;
   String? apr_status;
   String? apr_termtype;

   processItems(this.apr_billid, this.apr_payerid, this.apr_bill_gbl, this.apr_bill_type, this.apr_totalamt, this.apr_termamt, this.apr_paydate, this.apr_status,this.apr_termtype);


  processItems.fromJson(Map<String,dynamic> json){
    this.apr_billid = json['apr_billid'];
    this.apr_payerid = json['apr_payerid'];
    this.apr_bill_gbl = json['apr_bill_gbl'];
    this.apr_bill_type = json['apr_bill_type'];
    this.apr_totalamt = json['apr_totalamt'];
    this.apr_termamt = json['apr_termamt'];
    this.apr_paydate = json['apr_paydate'];
    this.apr_status = json['apr_status'];
    this.apr_termtype = json['apr_termtype'];

  }


}



//List<processItems> possitems = [
////  processItems("001", "11/11/2021", "99.99", "TermName", "COD","15.00","12",1),
////  processItems("002", "11/11/2021", "99.99", "TermName", "COD","15.00","12",2),
////  processItems("003", "11/11/2021", "99.99", "TermName", "COD","15.00","12",1),
////  processItems("004", "11/11/2021", "99.99", "TermName", "COD","15.00","12",3),
////  processItems("005", "11/11/2021", "99.99", "TermName", "COD","15.00","12",2),
////];


Future<List<processItems>?> getProcessList(String userID) async {

  List<processItems> processItems_ = [] ;

  print(userID);


  Uri url = Uri.parse("https://xeroxlinks.com/mypos/apps/dashboard.php");
  var data_post = {
    "getProcessPayment" : "tokenkey",
    "getProcessPayment_accountID" : base64.encode(utf8.encode(userID)).toString(),
  };

  var data = await http.post(url,body:data_post);

  if(data.statusCode == 200){

    if(data.body != "" && data.body != "noRecord"){

      var JsonData = json.decode(data.body);

      print(JsonData);
      for (var ma in JsonData) {

        try {


          processItems m = processItems.fromJson(ma);
          print(m.apr_billid);
          processItems_.add(m);

        } catch (e) {
          print(e.toString() + " < is json");
        }
//        items.add( billingData.fromJson(ma) );
      }


      return processItems_;


    }




  }else{

    return processItems_;

  }



}

