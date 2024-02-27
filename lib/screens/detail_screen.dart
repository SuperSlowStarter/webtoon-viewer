import 'package:flutter/material.dart';
import 'package:realtoomflix/models/wbt_episodes.dart';
import 'package:realtoomflix/models/webtoon_detail_model.dart';
import 'package:realtoomflix/services/api_service.dart';
import 'package:realtoomflix/widgets/episode_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WbtEpsodesModel>> episodes;
  late SharedPreferences prefs;

  bool isLiked = false;

  Future initPref() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons =
        prefs.getStringList('likedToons'); //likedToons <-- 좋아요 목록 List
    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        //widget.id <-- 현재 state에 대한 참조
        setState(() {
          isLiked = true;
        });
      }
    } else {
      await prefs.setStringList('likedToons', []);
    }
  } //좋아요 확인하기

  @override
  void initState() {
    //아래 두 메서드를 사용할 때 유저가 클릭한 웹툰의 id를 받아와야 하고 그러려면 statefulwidget이어야 한다.
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getToonEpisodesById(widget.id);
    initPref();
  }

  onHeratTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold -- to build main screen --
      backgroundColor: Colors.white,
      appBar: AppBar(
        //Appbar
        title: Text(
          widget
              .title, // ??? 약간 widget 계의 this. 같은 거네 widget. 이 DetailScreen을 의미함
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        centerTitle: true,
        elevation: 3,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,

        actions: [
          IconButton(
            onPressed: onHeratTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(45),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              offset: const Offset(10, 15),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ]),
                      width: 200,
                      child: Image.network(
                        widget.thumb,
                        headers: const {
                          'User-Agent':
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
                          'Referer': 'https://comic.naver.com',
                        },
                      ),
                    ),
                  ),
                ],
              ), //Image
              const SizedBox(height: 30),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "${snapshot.data!.genre} / ${snapshot.data!.age}",
                          style: const TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('...');
                },
              ),
              const SizedBox(height: 30),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episodes in snapshot.data!)
                          Episode(
                            episodes: episodes,
                            webtoonId: widget.id,
                          )
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
