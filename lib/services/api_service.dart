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
        '$baseUrl/$today'); //Url�� ������ִ� Ÿ���� Uri, string�� uri�� �ٲ��ִ°� uri.parse??
    final response = await http.get(url);

    if (response.statusCode == 200) {
      //status�� ����
      final List<dynamic> webtoons =
          jsonDecode(response.body); //status�� body�� �� ����
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
          jsonDecode(response.body); //response.body �� �׳� String�ε� �װ� json���� �ٲ���
      return WebtoonDetailModel.fromJson(
          webtoon); //json �� constructor�� �����ؼ� class�� �ٲ���
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
