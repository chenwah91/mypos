
import 'dart:convert';
import 'package:http/http.dart' as http;

class rfunction {


  Future<dynamic> GeneralPostReturn(String Url , Map<String , String> myData) async {


    var url = Uri.parse(Url);
    var data = myData;
    var res = await http.post(url,body:data);
    return jsonDecode(res.body);


  }




}