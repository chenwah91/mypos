import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

List<Item> itemFromJson(String str) => List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  Item({
    required this.description,
    required this.id,
    required this.name,
    required this.image,
    required this.itemId,
  });

  final String description;
  final String id;
  final String name;
  final String image;
  final String itemId;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    description: json["description"] == null ? null : json["description"],
    id: json["_id"] == null ? null : json["_id"],
    name: json["name"] == null ? null : json["name"],
    image: json["image"] == null ? null : json["image"]["url"],
    itemId: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "description": description == null ? null : description,
    "_id": id == null ? null : id,
    "name": name == null ? null : name,
    "image": image == null ? null : image,
    "id": itemId == null ? null : itemId,
  };
}

class Tag {
  Tag({
    required this.name,
    required this.price,
    required this.item,
    required this.id,
  });

  final String name;
  final double price;
  final String item;
  final String id;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    name: json["name"] == null ? null : json["name"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    item: json["item"] == null ? null : json["item"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "price": price == null ? null : price,
    "item": item == null ? null : item,
    "id": id == null ? null : id,
  };
}
