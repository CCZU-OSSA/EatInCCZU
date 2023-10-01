class Eatery {
  String location;
  String name;
  String description;
  List<String>? comments;
  List<Dish>? dishes;
  List<String>? images;

  ///```json
  /// {
  ///   "name":"eatry_0",
  ///   "location":"where",
  ///   "descrpiton":"",
  ///   "comments":[],
  ///   "dishes":[],
  ///   "images":[]
  /// }
  ///
  ///
  ///
  ///```
  Eatery(
      {this.location = "Unknown",
      this.name = "Unknown",
      this.description = "Unknown",
      this.comments,
      this.dishes}) {
    comments ??= [];
    dishes ??= [];
    images ??= [];
  }
}

class Dish {
  String name;
  double price;
  String description;
  List<String>? comments;
  List<String>? images;

  ///```json
  /// {
  ///   "name": "dish_0",
  ///   "price": "14.0",
  ///   "comments": [],
  ///   "images":[]
  /// }
  /// ```
  Dish(
      {this.name = "Unknown",
      this.description = "Unknown",
      this.price = -1,
      this.comments}) {
    comments ??= [];
    images ??= [];
  }
}
