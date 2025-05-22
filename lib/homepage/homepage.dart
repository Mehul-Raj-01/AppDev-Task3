import 'package:flutter/material.dart';
import 'recommendation.dart';
import 'now_playing.dart';
import 'top_rated.dart';
import 'tvshows.dart';
import '../nav_bar.dart';

// import 'movie_details.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          ListView(
            children: [
              // MovieDetails(id: 278),
              Recommendation(),
              NowPlaying(),
              TopRated(),
              TVShows(),
              SizedBox(height: 80),
            ],
          ),

          Align(alignment: Alignment.bottomCenter, child: Navbar()),
        ],
      ),
    );
  }
}
