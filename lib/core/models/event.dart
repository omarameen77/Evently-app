import 'package:event_app/core/models/category_model.dart';

class Event {
  static const String collectionName = "events";
  String? id;
  String? title;
  String? description;
  int? eventDate;
  int? eventTime;
  int? categoryId;
  List<String>? favoriteList;
  double? lat;
  double? lng;
  Event({
    this.id,
    this.title,
    this.description,
    this.eventDate,
    this.eventTime,
    this.categoryId,
    this.favoriteList,
    this.lat,
    this.lng,
  }) {
    if (lat == null || lng == null) {
      throw Exception("Event must have location");
    }
  }

  //create function to convert Event object to json object(to firestore)
  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate,
      'eventTime': eventTime,
      'categoryId': categoryId,
      'favoriteList': favoriteList ?? [],
      'lat': lat,
      'lng': lng,
    };
  }

  //named constructor to create an Event object from a Firestore document
  Event.fromFireStore(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    description = data['description'];
    eventDate = data['eventDate'];
    eventTime = data['eventTime'];
    favoriteList = List<String>.from(data['favoriteList'] ?? []);
    lat = data['lat'];
    lng = data['lng'];

    //داله بتدور في الليست عشان تجيب الابجكت اللي الايدي بتاعه بيساوي الايدي اللي جاي من الفايرستور
    final incomingCategoryId = data['categoryId'] as int?;
    //check if category found or not
    if (incomingCategoryId != null &&
        Category.categories.any((e) => e.id == incomingCategoryId)) {
      categoryId = incomingCategoryId;
    } else {
      // لو الـ category مش موجود، حط قيمة default أو null
      categoryId = null; // أو Category.categories.first.id
    }
  }
}
