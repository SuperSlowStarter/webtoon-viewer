import 'package:flutter/material.dart';
import 'package:realtoomflix/models/webtoon_model.dart';
import 'package:realtoomflix/screens/favorite_screen.dart';
import 'package:realtoomflix/services/api_service.dart';
import 'package:realtoomflix/widgets/wbt_widgrts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodayToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Scaffold -- to build main screen --
      backgroundColor: Colors.white,
      appBar: AppBar(
        //Appbar
        title: const Text(
          "Today's Webtoooon",
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
        foregroundColor: Colors.green, // --for here --

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FavoriteScreen(),
                    fullscreenDialog: true),
              );
            },
            icon: const Icon(
              Icons.star,
              size: 30,
            ),
          ),
        ],
      ),

      body: FutureBuilder(
        //모든 사진을 한번에 로딩하는 것은 최적화 측면에서 옳지 않다
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              //Column doesn't know how big is ---> ListView
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(child: makeList(snapshot))
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10,
      ),

      //Listview builder 표시되지 않는 item은 다 삭제해버림 --> 최적화
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length, //snapshot.data = list

      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },

      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
