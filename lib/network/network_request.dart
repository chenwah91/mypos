

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/model/post.dart';
import 'package:http/http.dart' as http ;
import 'dart:async';

List<Post> parsePost( String responeBody ){

  var l = json.decode(responeBody) as List<dynamic>;
  List<Post> posts = l.map((model) => Post.fromJson(model)).toList();
  return posts;
}

Future<List<Post>> fetchPosts(context, {int page=0}) async{

  final respone = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts?_start=$page&_limit=20'));

  if(respone.statusCode == 200){
      print(respone.body);
      return compute(parsePost,respone.body);

  }else if( respone.statusCode == 404){

    throw Exception("Not Found .. ");

  }else{

    throw Exception("Cant get Post ");

  }

}