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
          //Navigator.push : �ٸ� stateless widget�� �ε��ϰ� scaffold�ؼ� �ִϸ��̼� ȿ���� �Բ� ���� �Ѿ�� ��ö�� ���̰� ��
          context,
          MaterialPageRoute(
            fullscreenDialog: true, //�Ʒ����� �ö�´� ��ó�� ���̰�
            builder: (context) =>
                DetailScreen(title: title, thumb: thumb, id: id), //<---- Route
          ),
        ); //stateLess widget�� ���μ� �� ������ó�� �����ִ� �Լ�
      }, //tapDown, tapUp ����
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
