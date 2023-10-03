import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:eatincczu/application/bus.dart';
import 'package:eatincczu/pages/widgets/markdown.dart';
import 'package:flutter/material.dart';

Random rnd = Random();

abstract class JsonSerializable {
  Map<String, dynamic> toMap();
  String encode() {
    return jsonEncode(toMap());
  }
}

///```json
/// {
///   "name":"eatry_0",
///   "location":"where",
///   "descrpiton":"",
///   "dishes":[],
/// }
///```
class Eatery extends JsonSerializable {
  String location;
  String name;
  String description;
  List<Dish>? dishes;

  Eatery({
    this.location = "幻想乡",
    this.name = "夜雀食堂",
    this.description = "据说这里的烤八目鳗很好吃~",
    this.dishes,
  }) {
    dishes ??= [];
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }

  Dish getRandomDish() {
    return dishes == [] ? dishes![rnd.nextInt(dishes!.length)] : Dish();
  }

  static Eatery fromMap(Map<String, dynamic> map) {
    return Eatery(
        name: map["name"],
        location: map["location"],
        description: map["description"],
        dishes: List.generate((map["dishes"] as List).length,
            (index) => Dish.fromMap(map["dishes"][index])));
  }

  static Eatery fromString(String data) {
    return fromMap(jsonDecode(data));
  }
}

///```json
/// {
///   "name": "dish_0",
///   "price": "14.0",
///   "description":"",
///   "image":""
/// }
/// ```
class Dish extends JsonSerializable {
  String name;
  String price;
  String description;
  String? image;

  Dish(
      {this.name = "烤夜雀",
      this.description = "老板娘可不能吃😨",
      this.price = "?",
      this.image});

  @override
  Map<String, dynamic> toMap() {
    return {"name": name, "price": price, "image": image};
  }

  static Dish fromMap(Map<String, dynamic> map) {
    return Dish(name: map["name"], price: map["price"], image: map["images"]);
  }

  static Dish fromString(String data) {
    return fromMap(jsonDecode(data));
  }
}

///```json
/// {
///   "name": "list_0",
///   "publisher": "UnknownX",
///   "description":"",
///   "data":[]
/// }
/// ```
class EateryList extends JsonSerializable {
  String name;
  String publisher;
  String description;
  List<Eatery>? data;
  EateryList(
      {this.name = "Unknown",
      this.publisher = "Unknown",
      this.description = "Unknown",
      this.data}) {
    data ??= [];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "publisher": publisher,
      "description": description,
      "data": data
    };
  }

  Eatery getRandomEatry() {
    return data == [] ? data![rnd.nextInt(data!.length)] : Eatery();
  }

  static EateryList fromMap(Map<String, dynamic> map) {
    return EateryList(
        name: map["name"],
        publisher: map["publisher"],
        description: map["descrpition"],
        data: List.generate((map["data"] as List).length,
            (index) => Eatery.fromMap(map["data"][index])));
  }

  static EateryList fromString(String data) {
    return fromMap(jsonDecode(data));
  }

  static Future<EateryList> fromFile(String path) async {
    return fromString(await File(path).readAsString());
  }

  static EateryList fromFileSync(String path) {
    return fromString(File(path).readAsStringSync());
  }

  DisplayInfo getDisplayInfo({List<PanelInfo>? infos, Function? callback}) {
    infos ??= _infos;
    return DisplayInfo(
        ExpansionPanelList(
            expansionCallback: (panelIndex, isExpanded) {
              (callback ?? (v) {})(() {
                infos![panelIndex].doExpand();
              });
            },
            children: infos
                .map((e) => ExpansionPanel(
                    isExpanded: e.isExpand,
                    headerBuilder: (context, isExpanded) {
                      return markdownBodyString(e.head);
                    },
                    body: markdownBodyString(e.body)))
                .toList()),
        image: dish.image != null ? Image.network(dish.image!) : null);
  }
}

List<PanelInfo> generatefromED(Eatery eatery, Dish dish) {
  return [
    PanelInfo(head: "店名", body: eatery.name),
    PanelInfo(head: "位置", body: eatery.location),
    PanelInfo(head: "简述", body: eatery.description),
    PanelInfo(head: "选菜", body: dish.name)
  ];
}

Eatery eatery = EateryList().getRandomEatry();
Dish dish = eatery.getRandomDish();
List<PanelInfo> _infos = generatefromED(eatery, dish);

class DisplayInfo {
  ExpansionPanelList panellist;
  Image? image;
  DisplayInfo(this.panellist, {this.image}) {
    image ??= Image.asset("resource/images/mystia.png");
  }
}

class PanelInfo {
  bool isExpand = false;
  String head;
  String body;
  PanelInfo({this.head = "Nothing...", this.body = "Nothing..."});
  void doExpand() {
    isExpand = !isExpand;
  }
}
