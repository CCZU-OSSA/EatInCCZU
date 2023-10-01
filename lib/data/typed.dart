class Eatery {
  String location;
  String name;
  List<String>? comments;
  List<Dish>? dishes;
  Eatery(
      {this.location = "Unknown",
      this.name = "Unknown",
      this.comments,
      this.dishes}) {
    comments ??= [];
    dishes ??= [];
  }
}

class Dish {
  String name;
  double price;
  List<String>? comments;
  Dish({this.name = "Unknown", this.price = -1, this.comments}) {
    comments ??= [];
  }
}


