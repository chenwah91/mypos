
import 'dart:convert';

List<billingData> itemFromJson(String str) => List<billingData>.from(json.decode(str).map((x) => billingData.fromJson(x)));

String itemToJson(List<billingData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class billingData {

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



   String? gbl_id ;
   String?  gbl_type ;
   String?  bi_id ;
   String?  bi_totalamount ;
   String?  bi_category ;
   String?  bi_status ;
   String?  bi_payment_status ;
   String?  bi_startdate ;
   String?  bi_termname ;
   String?  bi_termtype ;
   String?  bi_termouth ;
   String?  bi_termamount ;
   String?  gbl_link ;
   String?  totalPaidAmount ;

//  billingData(this.billId,this.billtype,this.billmeetcode,this.billglobalcode,this.billamount);

  billingData(
      this.gbl_id,
      this.gbl_type,
      this.bi_id,
      this.bi_totalamount,
      this.bi_category,
      this.bi_status,
      this.bi_payment_status,
      this.bi_startdate,
      this.bi_termname,
      this.bi_termtype,
      this.bi_termouth,
      this.bi_termamount,
      this.gbl_link,
      this.totalPaidAmount,
      );

  billingData.fromJson(Map<String,dynamic> json){
    this.gbl_id = json['gbl_id'];
    this.gbl_type = json['gbl_type'];
    this.bi_id = json['bi_id'];
    this.bi_totalamount = json['bi_totalamount'];
    this.bi_category = json['bi_category'];
    this.bi_status = json['bi_status'];
    this.bi_payment_status = json['bi_payment_status'];
    this.bi_startdate = json['bi_startdate'];
    this.bi_termname = json['bi_termname'];
    this.bi_termtype = json['bi_termtype'];
    this.bi_termouth = json['bi_termouth'];
    this.bi_termamount = json['bi_termamount'];
    this.gbl_link = json['gbl_link'];
    this.totalPaidAmount = json['totalPaidAmount'];
  }

  Map<String, dynamic> toJson() => {
    "gbl_id": gbl_id == null ? null : gbl_id,
    "gbl_type": gbl_type == null ? null : gbl_type,
    "bi_id": bi_id == null ? null : bi_id,
    "bi_totalamount": bi_totalamount == null ? null : bi_totalamount,
    "bi_category": bi_category == null ? null : bi_category,
    "bi_status": bi_status == null ? null : bi_status,
    "bi_payment_status": bi_payment_status == null ? null : bi_payment_status,
    "bi_startdate": bi_startdate == null ? null : bi_startdate,
    "bi_termname": bi_termname == null ? null : bi_termname,
    "bi_termtype": bi_termtype == null ? null : bi_termtype,
    "bi_termouth": bi_termouth == null ? null : bi_termouth,
    "bi_termamount": bi_termamount == null ? null : bi_termamount,
    "gbl_link": gbl_link == null ? null : gbl_link,
    "totalPaidAmount": totalPaidAmount == null ? null : totalPaidAmount,
  };

}