import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../key/key.dart';
import 'cards/description_card.dart';
import '../nav_bar.dart';

class SearchBarC extends StatefulWidget {
  const SearchBarC({super.key});

  @override
  State<SearchBarC> createState() => _SearchBarCState();
}

class _SearchBarCState extends State<SearchBarC> {
  List<Map<String, dynamic>> searchBarCResult = [];
  final TextEditingController searchText = TextEditingController();
  bool isLoading = false;

  Future<void> search(String searchedText) async {
    final url =
        "https://api.themoviedb.org/3/search/movie?query=$searchedText&api_key=$key";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      final dataResult = data['results'];
      setState(() {
        // print(dataResult);
        searchBarCResult =
            dataResult.map<Map<String, dynamic>>((item) {
              return {
                'id': item['id'],
                'title': item['title'] ?? item['name'],
                'vote_average': item['vote_average'],
                'indexno': dataResult.indexOf(item),
                'poster_path': item['poster_path'],
                'overview': item['overview'] ?? '',
              };
            }).toList();
        // print(searchBarCResult);
        isLoading = false;
      });
    } else {
      print('Failed to load movies. Status: ${response.statusCode}');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 8,
                  left: 0,
                  right: 16,
                ),
                child: Row(
                  children: [
                    Container(
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: SearchBar(
                        leading: Icon(Icons.search),
                        hintText: 'Search Movies',

                        onSubmitted: (value) {
                          search(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              if (isLoading) const CircularProgressIndicator(),
              if (searchBarCResult.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.movie_outlined, size: 100, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Search for a movie...',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                )
              else if (!isLoading)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: searchBarCResult.length,
                    itemBuilder: (context, index) {
                      final movie = searchBarCResult[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 12,
                        ),
                        child: DescriptionCard(
                          url: movie['poster_path'] ?? '',
                          movieName: movie['title'] ?? 'Unknown Title',
                          rating: movie['vote_average'].toStringAsFixed(1),
                          overview: movie['overview'],
                          id: movie['id'],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          Align(alignment: Alignment.bottomCenter, child: Navbar()),
        ],
      ),
    );
  }
}
