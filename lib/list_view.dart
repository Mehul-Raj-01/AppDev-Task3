import 'package:flutter/material.dart';
import 'cards/description_card.dart';
import 'nav_bar.dart';

//url lega input me aur pura listview dega
class CardList extends StatelessWidget {
  final List<Map<String, dynamic>> listItems;
  final String listTitle;
  const CardList({super.key, required this.listItems, required this.listTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16, top: 40),
                child: Text(
                  listTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 255, 103, 103),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: listItems.length,
                  itemBuilder: (context, index) {
                    final movie = listItems[index];
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

          //ye raha back button
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
          Align(alignment: Alignment.bottomCenter, child: Navbar()),
        ],
      ),
    );
  }
}
