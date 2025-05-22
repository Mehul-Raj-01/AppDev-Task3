import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../movie_desc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomImageViewer extends StatelessWidget {
  final String url;
  final String posterpath;
  final String? movieName;
  final List<dynamic> genres;
  final BoxFit? fit;
  final double? radius;
  final int id;
  final String overview;
  final double vote_average;

  final _db = Hive.box('db');
  late final Map<String, dynamic> movieData;

  CustomImageViewer({
    super.key,
    required this.url,
    required this.movieName,
    required this.genres,
    required this.id,
    required this.overview,
    required this.vote_average,
    required this.posterpath,
    this.fit,
    this.radius,
  }) {
    movieData = {
      'poster_path': posterpath,
      'title': movieName,
      'id': id,
      'overview': overview,
      'vote_average': vote_average,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieDetails(id: id)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://image.tmdb.org/t/p/original$url',
              fit: fit ?? BoxFit.cover,
              imageBuilder:
                  (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius ?? 8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: fit ?? BoxFit.cover,
                      ),
                    ),
                  ),
              placeholder: (context, url) => Container(),
              errorWidget:
                  (context, url, error) => const Icon(Icons.error_outline),
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

            //movie title
            Positioned(
              bottom: 40,
              left: 00,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Text(
                  movieName ?? "movie",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PoetsenOne',
                    fontSize: 24,
                    // fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                ),
              ),
            ),

            // Genres
            Positioned(
              bottom: 20,
              left: 12,
              right: 16,
              child: Text(
                genres.take(4).join('   •   '),
                style: const TextStyle(
                  color: Color.fromARGB(126, 255, 255, 255),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              right: 10,
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
                              .map((e) => Map<String, dynamic>.from(e))
                              .toList();

                      if (!wishlist.any(
                        (item) => item['id'] == movieData['id'],
                      )) {
                        wishlist.add(movieData);
                        _db.put('wishlist', wishlist);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to Wishlist')),
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
          ],
        ),
      ),
    );
  }
}
