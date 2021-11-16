
import 'dart:convert';
import 'package:http/http.dart' as http;


class fcm_cui {

  static Future<void> RegisterAndUpdateFCMtoken(String id , String token) async {


    var url = Uri.parse("https://xeroxlinks.com/mypos/apps/firebase_createToken.php");
    var data = {
      "accid" : id,
      "token" : token,
    };

    var res = await http.post(url,body:data);
    if(jsonDecode(res.body) == "TokenUpdated"){
      print("TokenUpdated");
    }else if(jsonDecode(res.body) == "TokenAdd"){
      print("TokenAdd");
    }else{
      print(jsonDecode(res.body) );

    }



  }




}