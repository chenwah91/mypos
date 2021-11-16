
import 'dart:convert';

List<productData> itemFromJson(String str) => List<productData>.from(json.decode(str).map((x) => productData.fromJson(x)));

String itemToJson(List<productData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class productData {

//  billingData({
//    required this.billId,
//    required this.billtype,
//    required this.billamount,
//  });


//  "gbl_id"=>$row['gbl_id'],
//  "gbl_type"=>$row['gbl_type'] ,
//  "bi_id"=>$row['bi_id'] ,
//  "bi_totalamount"=>$row['bi_totalamount'],
//  "bi_category"=>$row['bi_category'],
//  "bi_status"=>$row['bi_status'],
//  "bi_payment_status"=>$row['bi_payment_status'],
//  "bi_startdate"=>$row['bi_startdate'],
//  "bi_termname"=>$row['bi_termname'],
//  "bi_termtype"=>$row['bi_termtype'],
//  "bi_termouth"=>$row['bi_termouth'],
//  "bi_termamount"=>$row['bi_termamount'],
//  "bi_termouth"=>$row['bi_totalamount'],



  String?  pid ;
  String?  p_name ;
  String?  p_category ;
  String?  p_subcategory ;
  String?  p_ex_carstatus ;
  String?  p_price ;
  String?  p_cost ;
  String?  p_quantity ;
  String?  imglink ;

  String?  p_uom ;
  String?  p_desc ;
  String?  p_shortdesc ;

//  billingData(this.billId,this.billtype,this.billmeetcode,this.billglobalcode,this.billamount);

  productData(
      this.pid,
      this.p_name,
      this.p_category,
      this.p_subcategory,
      this.p_ex_carstatus,
      this.p_price,
      this.p_cost,
      this.p_quantity,
      this.imglink,
      this.p_uom,
      this.p_desc,
      this.p_shortdesc,


      );

  productData.fromJson(Map<String,dynamic> json){
    this.pid = json['pid'];
    this.p_name = json['p_name'];
    this.p_category = json['p_category'];
    this.p_subcategory = json['p_subcategory'];
    this.p_ex_carstatus = json['p_ex_carstatus'];
    this.p_price = json['p_price'];
    this.p_cost = json['p_cost'];
    this.p_quantity = json['p_quantity'];
    this.imglink = json['imglink'];
    this.p_uom = json['p_uom'];
    this.p_desc = json['p_desc'];
    this.p_shortdesc = json['p_shortdesc'];
  }

  Map<String, dynamic> toJson() => {
    "pid": pid == null ? null : pid,
    "p_name": p_name == null ? null : p_name,
    "p_category": p_category == null ? null : p_category,
    "p_subcategory": p_subcategory == null ? null : p_subcategory,
    "p_ex_carstatus": p_ex_carstatus == null ? null : p_ex_carstatus,
    "p_price": p_price == null ? null : p_price,
    "p_cost": p_cost == null ? null : p_cost,
    "p_quantity": p_quantity == null ? null : p_quantity,
    "imglink": imglink == null ? null : imglink,
    "p_uom": p_uom == null ? null : p_uom,
    "p_desc": p_desc == null ? null : p_desc,
    "p_shortdesc": p_shortdesc == null ? null : p_shortdesc,
  };

}