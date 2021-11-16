
import 'dart:convert';

List<payRcdItems> itemFromJson(String str) => List<payRcdItems>.from(json.decode(str).map((x) => payRcdItems.fromJson(x)));

String itemToJson(List<payRcdItems> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class payRcdItems {

  String? pay_amount ;
  String? pay_status ;
  String? pay_createdate ;


  payRcdItems(
      this.pay_amount,
      this.pay_status,
      this.pay_createdate,
      );

  payRcdItems.fromJson(Map<String,dynamic> json){
    this.pay_amount = json['pay_amount'];
    this.pay_status = json['pay_status'];
    this.pay_createdate = json['pay_createdate'];
  }

  Map<String, dynamic> toJson() => {
    "pay_amount": pay_amount == null ? null : pay_amount,
    "pay_status": pay_status == null ? null : pay_status,
    "pay_createdate": pay_createdate == null ? null : pay_createdate,

  };

}