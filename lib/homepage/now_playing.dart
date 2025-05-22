import 'package:flutter/material.dart';
// import 'package:flutter_application_1/movie_desc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../key/key.dart';
import '../cards/basic_card.dart';
import 'dart:math';
import 'package:flutter_application_1/list_view.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  List<Map<String, dynamic>> trendingList = [];
  bool isLoading = true;

  Future<void> trendingListHome() async {
    final url = "https://api.themoviedb.org/3/movie/now_playing?api_key=$key";
    var response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final dataResult = data['results'];
      setState(() {
        // print(dataResult);
        trendingList =
            dataResult.map<Map<String, dynamic>>((item) {
              return {
                'id': item['id'],
                'title': item['title'] ?? item['name'],
                // 'backdrop_path': item['backdrop_path'],
                'vote_average': item['vote_average'],
                // 'media_type': item['media_type'],
                'indexno': dataResult.indexOf(item),
                'poster_path': item['poster_path'],
                'overview': item['overview'],
              };
            }).toList();
        isLoading = false;
      });
    } else {
      print('Failed to load movies. Status: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  }

  final random = Random(12);

  @override
  void initState() {
    trendingListHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 32,
            right: 16,
            bottom: 8,
            left: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Now playing',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CardList(
                            listItems: trendingList,
                            listTitle: "Now Playing 🎥",
                          ),
                    ),
                  );
                },
                child: Text(
                  'see all>',
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(160, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 227,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 4),
            children:
                trendingList.take(8).map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CardViewer(
                        id: i['id'],
                        url: i['poster_path'],
                        movieName: i['title'],
                        rating: i['vote_average'].toStringAsFixed(2),
                        duration: "1h ${30 + random.nextInt(29)}m",
                      );
                    },
                  );
                }).toList(),
          ),
        ),
        // CardViewer(
        //   url: '/yFHHfHcUgGAxziP1C3lLt0q2T4s.jpg',
        //   movieName: "The Thunderbolts",
        //   rating: "9.42",
        //   duration: "1h 32m",
        // ),
      ],
    );
  }
}
