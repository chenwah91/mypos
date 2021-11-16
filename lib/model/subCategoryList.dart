
import 'dart:convert';

List<subCategoryItems> itemFromJson(String str) => List<subCategoryItems>.from(json.decode(str).map((x) => subCategoryItems.fromJson(x)));

String itemToJson(List<subCategoryItems> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class subCategoryItems {

  String? pcs_id ;
  String? pcs_pcid ;
  String? pcs_name ;


  subCategoryItems(
      this.pcs_id,
      this.pcs_pcid,
      this.pcs_name,
      );

  subCategoryItems.fromJson(Map<String,dynamic> json){
    this.pcs_id = json['pcs_id'];
    this.pcs_pcid = json['pcs_pcid'];
    this.pcs_name = json['pcs_name'];
  }

  Map<String, dynamic> toJson() => {
    "pcs_id": pcs_id == null ? null : pcs_id,
    "pc_name": pcs_pcid == null ? null : pcs_pcid,
    "pcs_name": pcs_name == null ? null : pcs_name,

  };

}