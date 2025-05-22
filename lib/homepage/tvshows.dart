import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../key/key.dart';
import '../cards/basic_card.dart';
import 'dart:math';
import 'package:flutter_application_1/list_view.dart';

class TVShows extends StatefulWidget {
  const TVShows({super.key});

  @override
  State<TVShows> createState() => _TVShowsState();
}

class _TVShowsState extends State<TVShows> {
  List<Map<String, dynamic>> trendingList = [];
  bool isLoading = true;

  Future<void> trendingListHome() async {
    final url = "https://api.themoviedb.org/3/tv/popular";
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
                'title': item['name'] ?? item['original_name'],
                'vote_average': item['vote_average'],
                'indexno': dataResult.indexOf(item),
                'poster_path': item['poster_path'],
                'origin_country': item['origin_country'].join('.'),
                'overview': item['overview'],
              };
            }).toList();
        // print(trendingList);
        isLoading = false;
      });
    } else {
      print('Failed to load movies. Status: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  }

  final random = Random(10);

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
                'TV shows',
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
                            listTitle: "TV Shows 📺",
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
                trendingList.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CardViewer(
                        id: i['id'],
                        url: i['poster_path'],
                        movieName: i['title'],
                        rating: i['vote_average'].toStringAsFixed(2),
                        duration:
                            i['origin_country'], //here passing origin country mega trick
                      );
                    },
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
