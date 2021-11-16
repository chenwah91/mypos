
import 'dart:convert';

List<categoryItems> itemFromJson(String str) => List<categoryItems>.from(json.decode(str).map((x) => categoryItems.fromJson(x)));

String itemToJson(List<categoryItems> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class categoryItems {

  String? pc_id ;
  String? pc_name ;


  categoryItems(
      this.pc_id,
      this.pc_name,
      );

  categoryItems.fromJson(Map<String,dynamic> json){
    this.pc_id = json['pc_id'];
    this.pc_name = json['pc_name'];
  }

  Map<String, dynamic> toJson() => {
    "pc_id": pc_id == null ? null : pc_id,
    "pc_name": pc_name == null ? null : pc_name,


  };

}