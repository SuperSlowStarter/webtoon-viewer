import 'package:flutter/material.dart';
import 'package:realtoomflix/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          //Navigator.push : 다른 stateless widget을 로드하고 scaffold해서 애니메이션 효과와 함께 탭을 넘어가는 것철머 보이게 함
          context,
          MaterialPageRoute(
            fullscreenDialog: true, //아래에서 올라온는 것처럼 보이게
            builder: (context) =>
                DetailScreen(title: title, thumb: thumb, id: id), //<---- Route
          ),
        ); //stateLess widget을 감싸서 새 페이지처럼 보여주는 함수
      }, //tapDown, tapUp 존재
      child: Column(
        children: [
          Hero(
            tag: id,
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
              width: 250,
              child: Image.network(
                thumb,
                headers: const {
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
                  'Referer': 'https://comic.naver.com',
                },
              ),
            ),
          ), //Image
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ), //Title
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
