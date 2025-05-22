import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/search_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'key/key.dart';
import 'list_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  List<Map<String, dynamic>> trendingList = [];
  bool isLoading = true;

  //loading the data from the wishlish
  final _db = Hive.box('db');

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

  @override
  void initState() {
    trendingListHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(93, 27, 21, 19),
            ),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Icon(Icons.home ),
                // Icon(Icons.trending_down),
                // Icon(Icons.search),
                // Icon(Icons.favorite)
                IconButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: Icon(Icons.home, color: Colors.white),
                  disabledColor: Colors.grey[600],
                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CardList(
                              listItems: trendingList,
                              listTitle: "Trending 🔥",
                            ),
                      ),
                    );
                  },
                  icon: Icon(Icons.whatshot, color: Colors.white),

                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchBarC()),
                    );
                  },
                  icon: Icon(Icons.search, color: Colors.white),

                  iconSize: 32,
                ),
                IconButton(
                  onPressed: () {
                    final List<dynamic> rawWishlist = _db.get(
                      'wishlist',
                      defaultValue: [],
                    );
                    // print(rawWishlist);
                    final List<Map<String, dynamic>> wishlist =
                        rawWishlist
                            .map((e) => Map<String, dynamic>.from(e))
                            .toList();
                    // print(rawWishlist);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CardList(
                              listItems: wishlist,
                              listTitle: "Wishlist 💖",
                            ),
                      ),
                    );
                  },
                  icon: Icon(Icons.favorite, color: Colors.white),

                  iconSize: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
