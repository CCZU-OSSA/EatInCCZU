import 'dart:convert';
import 'dart:io';

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
///   "images":[]
/// }
///```
class Eatery extends JsonSerializable {
  String location;
  String name;
  String description;
  List<Dish>? dishes;
  List<String>? images;

  Eatery(
      {this.location = "Unknown",
      this.name = "Unknown",
      this.description = "Unknown",
      this.dishes,
      this.images}) {
    dishes ??= [];
    images ??= [];
  }

  @override
  Map<String, dynamic> toMap() {
    return {};
  }

  static Eatery fromMap(Map<String, dynamic> map) {
    return Eatery(
        name: map["name"],
        location: map["location"],
        description: map["description"],
        images: map["images"],
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
///   "images":[]
/// }
/// ```
class Dish extends JsonSerializable {
  String name;
  double price;
  String description;
  List<String>? images;

  Dish(
      {this.name = "Unknown",
      this.description = "Unknown",
      this.price = -1,
      this.images}) {
    images ??= [];
  }

  @override
  Map<String, dynamic> toMap() {
    return {"name": name, "price": price, "images": images};
  }

  static Dish fromMap(Map<String, dynamic> map) {
    return Dish(name: map["name"], price: map["price"], images: map["images"]);
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
}
