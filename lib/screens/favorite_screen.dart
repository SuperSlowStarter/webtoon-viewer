import 'package:flutter/material.dart';
import 'package:realtoomflix/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late SharedPreferences prefs;
  List<String>? likedToonsIds;
  Map<String, String> toonTitles = {};

  @override
  void initState() {
    super.initState();
    initPref();
  }

  Future<void> getToonTitle(String id) async {
    try {
      var toonDetail = await ApiService.getToonById(id);
      setState(() {
        toonTitles[id] = toonDetail.title;
      });
    } catch (e) {
      print("Error getting webtoon detail: $e");
    }
  }

  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      likedToonsIds = prefs.getStringList('likedToons');
    });
    if (likedToonsIds != null) {
      for (var id in likedToonsIds!) {
        getToonTitle(id); // 각 웹툰 ID에 대한 제목을 가져옵니다.
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: likedToonsIds == null
          ? const Center(child: Text("No favorites added"))
          : ListView.builder(
              itemCount: likedToonsIds!.length,
              itemBuilder: (context, index) {
                var id = likedToonsIds![index];
                var title = toonTitles[id] ?? "Loading...";

                return GestureDetector(
                  onTap: () => _launchUrl(
                      "https://comic.naver.com/webtoon/detail?titleId=$id"),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        title: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
