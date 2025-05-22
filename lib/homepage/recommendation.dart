import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../cards/banner_card.dart';
import '../key/key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Recommendation extends StatefulWidget {
  const Recommendation({super.key});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  late CarouselSliderController outerCarouselController;
  int outerCurrentPage = 0;

  List<Map<String, dynamic>> trendingList =
      []; //this is similar to creating an obj
  bool isLoading = true;
  final Map<int, String> genreMap = {
    28: "Action",
    12: "Adventure",
    16: "Animation",
    35: "Comedy",
    80: "Crime",
    99: "Documentary",
    18: "Drama",
    10751: "Family",
    14: "Fantasy",
    36: "History",
    27: "Horror",
    10402: "Music",
    9648: "Mystery",
    10749: "Romance",
    878: "Science Fiction",
    10770: "TV Movie",
    53: "Thriller",
    10752: "War",
    37: "Western",
  };

  Future<void> trendingListHome() async {
    final url = "https://api.themoviedb.org/3/trending/all/week?api_key=$key";
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
                'backdrop_path': item['backdrop_path'],
                'vote_average': item['vote_average'],
                'media_type': item['media_type'],
                'indexno': dataResult.indexOf(item),
                'poster_path': item['poster_path'],
                'title': item['title'] ?? item['name'],
                'overview': item['overview'],
                'genres':
                    (item['genre_ids'] as List<dynamic>)
                        .map((id) => genreMap[id] ?? 'Unknown')
                        .toList(),
              };
            }).toList();
        isLoading = false;
      });
    } else {
      print('Failed to load movies. Status: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    outerCarouselController = CarouselSliderController();
    trendingListHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Recommended(),
        outerBannerSlider(),
      ],
    );
  }

  Widget outerBannerSlider() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider(
            carouselController: outerCarouselController,

            // It's options
            options: CarouselOptions(
              autoPlay: true,
              enableInfiniteScroll: true,
              aspectRatio: 1 / 1,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  outerCurrentPage = index;
                });
              },
            ),

            // Items
            items:
                trendingList.take(6).map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      /// Custom Image Viewer widget
                      return CustomImageViewer(
                        posterpath: i['poster_path'],
                        overview: i['overview'],
                        vote_average: i['vote_average'],
                        id: i['id'],
                        url: i['backdrop_path'],
                        fit: BoxFit.cover,
                        radius: 0,
                        movieName: i['title'],
                        genres: i['genres'],
                      );
                    },
                  );
                }).toList(),
          ),
        ),

        //indicator of the carousel banner
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(6, (index) {
              bool isSelected = outerCurrentPage == index;
              return GestureDetector(
                onTap: () {
                  outerCarouselController.animateToPage(index);
                },
                child: AnimatedContainer(
                  width: isSelected ? 30 : 10,
                  height: 10,
                  margin: EdgeInsets.symmetric(horizontal: isSelected ? 6 : 3),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color.fromARGB(255, 187, 0, 0)
                            : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
