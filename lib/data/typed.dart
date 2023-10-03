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
///   "description":"",
///   "image":"",
/// }
///```
class Eatery extends JsonSerializable {
  String location;
  String name;
  String description;
  String? image;

  Eatery({
    this.location = "幻想乡",
    this.name = "夜雀食堂",
    this.description = "据说这里的烤八目鳗很好吃~",
    this.image,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "location": location,
      "name": name,
      "description": description,
      "image": image
    };
  }

  static Eatery fromMap(Map<String, dynamic> map) {
    return Eatery(
        name: map["name"],
        location: map["location"],
        description: map["description"],
        image: map["image"]);
  }

  static Eatery fromString(String data) {
    return fromMap(jsonDecode(data));
  }

  @override
  String toString() {
    return toMap().toString();
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
      {this.name = "default",
      this.publisher = "Developer",
      this.description = "Unknown",
      this.data}) {
    data ??= [Eatery()];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "publisher": publisher,
      "description": description,
      "data": data!.map((e) => e.toMap()).toList()
    };
  }

  Eatery getRandomEatry() {
    return data != [] ? data![rnd.nextInt(data!.length)] : Eatery();
  }

  static EateryList fromMap(Map<String, dynamic> map) {
    return EateryList(
        name: map["name"],
        publisher: map["publisher"],
        description: map["description"],
        data: List.generate((map["data"] as List).length,
            (index) => Eatery.fromMap(map["data"][index])));
  }

  void sync() async {
    File("${await getPlatPath()}/eaterylist.json").writeAsString(encode());
  }

  static EateryList fromString(String data) {
    return fromMap(jsonDecode(data));
  }

  static Future<EateryList> fromPath(String path) async {
    return await fromFile(File(path));
  }

  static Future<EateryList> fromFile(File file) async {
    return fromString(await file.readAsString());
  }

  static EateryList fromFileSync(File file) {
    return fromString(file.readAsStringSync());
  }

  static EateryList fromPathSync(String path) {
    return fromFileSync(File(path));
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

List<PanelInfo> generatePanelInfo(Eatery eatery) {
  return [
    PanelInfo(head: "**店名**", body: eatery.name),
    PanelInfo(head: "**位置**", body: eatery.location),
    PanelInfo(head: "**简述**", body: eatery.description),
  ];
}

Eatery _eatery = Eatery();
List<PanelInfo> _infos = generatePanelInfo(_eatery);
List<PanelInfo> getInfos() {
  return _infos;
}

void setInfos(Eatery eatery) {
  _infos.map((e) => e.isExpand = false);
  _eatery = eatery;
  _infos = generatePanelInfo(eatery);
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
      image: _eatery.image != null ? Image.network(_eatery.image!) : null);
}

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
