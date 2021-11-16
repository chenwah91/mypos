

import 'package:flutter_app/model/post.dart';
//import 'package:flutter_riverpod/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: top_level_function_literal_block
final postLoadStates = StateNotifierProvider((ref){

  return  PostList([]);

});