import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:realtoomflix/models/wbt_episodes.dart';
import 'package:realtoomflix/models/webtoon_detail_model.dart';
import 'package:realtoomflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static String whatIsClassName() {
    return "APIService";
  }

  static Future<List<WebtoonModel>> getTodayToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse(
        '$baseUrl/$today'); //Url을 만들어주는 타입이 Uri, string을 uri로 바꿔주는게 uri.parse??
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //status가 뭔데
      final List<dynamic> webtoons =
          jsonDecode(response.body); //status의 body는 또 뭔데
      for (var webtoon in webtoons) {
        final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(toon);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon =
          jsonDecode(response.body); //response.body 는 그냥 String인데 그걸 json으로 바꿔줌
      return WebtoonDetailModel.fromJson(
          webtoon); //json 을 constructor로 전달해서 class로 바꿔줌
    }
    throw Error();
  }

  static Future<WebtoonModel> getToonById2(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonModel.fromJson(webtoon);
    }
    throw Error();
  }

  static Future<List<WbtEpsodesModel>> getToonEpisodesById(String id) async {
    List<WbtEpsodesModel> episodesInstances = [];

    final url = Uri.parse('$baseUrl/$id/episodes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episodes in episodes) {
        episodesInstances.add(WbtEpsodesModel.fromJson(episodes));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
