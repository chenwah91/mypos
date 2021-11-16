
//import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PostList extends StateNotifier<List<Post>>{
  PostList(List<Post> state) : super(state);


//  PostList(List<Post> state):super(state ?? []);

  void addAll( List<Post> posts ){
      state.addAll(posts);
  }

  void clear(){
      state.clear();
  }


}



class Post {
  int? userId;
  int? id;
  String? title;
  String? body;

  Post({required this.userId, required this.id, required this.title, required this.body});

  Post.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }

}
