import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'key/key.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'nav_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MovieDetails extends StatefulWidget {
  final int id;
  const MovieDetails({super.key, required this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  Map<String, dynamic> movieData = {};
  bool isLoading = true;

  final _db = Hive.box('db');

  Future<void> loadMovieData() async {
    final url =
        "https://api.themoviedb.org/3/movie/${widget.id}?language=en-US";
    var response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // print(data);
      // final dataResult = data;
      setState(() {
        // print(dataResult);
        movieData = {
          'id': data['id'],
          'title': data['original_title'] ?? data['original_name'],
          'vote_average': data['vote_average'],
          'poster_path': data['poster_path'],
          'overview': data['overview'],
          'release_date': data['release_date'],
          'vote_count': data['vote_count'],
          'tagline': data['tagline'],
          'budget': data['budget'],
          'homepage': data['homepage'] ?? 'Unavailable',
          'original_language': data['original_language'],
          'popularity': data['popularity'],
          'revenue': data['revenue'],
          'runtime': data['runtime'],
          'adult': data['adult'],
          'origin_country': data['origin_country'].join(','),
          'genres':
              (data['genres'] as List<dynamic>)
                  .map((genre) => genre['name'] as String)
                  .toList(),
        };
        isLoading = false;
      });
      // print(movieData['genres']);
    } else {
      print('Failed to load movies. Status: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    loadMovieData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    //pic
                    SizedBox(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/original${movieData['poster_path']}",
                        fit: BoxFit.cover,
                        imageBuilder:
                            (context, imageProvider) => Container(
                              width: 120,
                              height: 172.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                        placeholder: (context, url) => Container(),
                        errorWidget:
                            (context, url, error) =>
                                const Icon(Icons.error_outline),
                      ),
                    ),

                    //thoda black layer
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 200,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xFF141218), Colors.transparent],
                          ),
                        ),
                      ),
                    ),

                    //details
                    Positioned(
                      bottom: 00,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movieData['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'PoetsenOne',
                                fontSize: 22,
                                // fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                '${movieData['release_date'].substring(0, 4)}  ・ ${(movieData['runtime'] / 60).toInt()}h ${movieData['runtime'] % 60}m ',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(
                                    160,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                ),

                                Text(
                                  "${movieData['vote_average']}  ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: const Color.fromARGB(
                                      160,
                                      255,
                                      255,
                                      255,
                                    ),
                                  ),
                                ),
                                Text(
                                  '  (${(movieData['vote_count'] / 1000).toInt()}k)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(
                                      160,
                                      255,
                                      255,
                                      255,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    //go back
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF141218),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: const Color.fromARGB(232, 255, 255, 255),
                            size: 28,
                          ),
                          // color: Colors.black54,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),

                    //this is the add to wish list button
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {},
                        child: ClipOval(
                          child: Material(
                            color: const Color.fromARGB(129, 255, 255, 255),
                            child: InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () {
                                final List<dynamic> rawWishlist = _db.get(
                                  'wishlist',
                                  defaultValue: [],
                                );

                                final List<Map<String, dynamic>> wishlist =
                                    rawWishlist
                                        .map(
                                          (e) => Map<String, dynamic>.from(e),
                                        )
                                        .toList();

                                if (!wishlist.any(
                                  (item) => item['id'] == movieData['id'],
                                )) {
                                  wishlist.add(movieData);
                                  _db.put('wishlist', wishlist);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to Wishlist'),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //genres
                Row(
                  children:
                      (movieData['genres'] as List<String>).take(4).map((i) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 24,
                            right: 4,
                            bottom: 8,
                            left: 4,
                          ),
                          child: Container(
                            // height: 80,
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(150, 255, 82, 82),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Text(
                              i,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),

                //movie ka tagline
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "\" ${movieData['tagline']} \"",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                //story ka heading
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 0, left: 16),
                  child: Text(
                    'Story',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),

                //story ka content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                  child: Text(
                    movieData['overview'],
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ),

                //general Details about the movie
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 16),
                        child: Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 230,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 6,
                          shrinkWrap: true,
                          children: [
                            Text('Language', style: TextStyle(fontSize: 17)),
                            Text(
                              movieData['original_language'],
                              style: TextStyle(fontSize: 17),
                            ),
                            Text('Adult Rated', style: TextStyle(fontSize: 17)),
                            Text(
                              movieData['adult'] ? "Yes" : "No",
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              'Popularity Score',
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              movieData['popularity'].toString(),
                              style: TextStyle(fontSize: 17),
                            ),
                            Text('Budget', style: TextStyle(fontSize: 17)),
                            Text(
                              movieData['budget'].toString(),
                              style: TextStyle(fontSize: 17),
                            ),
                            Text('Homepage', style: TextStyle(fontSize: 17)),
                            Text(
                              movieData['homepage'].length > 12
                                  ? movieData['homepage'].toString().substring(
                                    12,
                                  )
                                  : 'unavailable',
                              style: TextStyle(fontSize: 17),
                              softWrap: true,
                              maxLines: 1,
                            ),
                            Text('Country', style: TextStyle(fontSize: 17)),
                            Text(
                              movieData['origin_country'].toString(),
                              style: TextStyle(fontSize: 17),
                            ),
                            Text('Revenue', style: TextStyle(fontSize: 17)),
                            Text(
                              movieData['revenue'].toString(),
                              style: TextStyle(fontSize: 17),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //extra bottom paddin
                SizedBox(height: 60),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: Navbar()),
        ],
      ),
    );
  }
}
