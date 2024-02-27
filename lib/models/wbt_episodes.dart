class WbtEpsodesModel {
  final String id, title, rating, date;

  WbtEpsodesModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        rating = json['rating'],
        date = json['date'];
}
