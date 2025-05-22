import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../movie_desc.dart';
// import 'package:hive_flutter/hive_flutter.dart';

class DescriptionCard extends StatelessWidget {
  final String url;
  final String movieName;
  final String rating;
  final String overview;
  final int id;

  const DescriptionCard({
    super.key,
    required this.url,
    required this.movieName,
    required this.rating,
    required this.overview,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MovieDetails(id: id)),
        );
      },
      child: Container(
        height: 172.5,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.fromARGB(255, 33, 32, 37),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              // color: Colors.red,
              imageUrl: 'https://image.tmdb.org/t/p/original$url',
              fit: BoxFit.contain,
              imageBuilder:
                  (context, imageProvider) => Container(
                    width: 120,
                    height: 172.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

              placeholder: (context, url) => Container(),
              errorWidget:
                  (context, url, error) => Container(
                    width: 120,
                    height: 172.5,
                    color: Color.fromARGB(255, 0, 0, 0),
                    child: const Icon(Icons.error_outline),
                  ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
                    child: Text(
                      movieName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Text(
                          "1h 42 m",
                          style: TextStyle(
                            color: const Color.fromARGB(170, 255, 255, 255),
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.star, size: 20, color: Colors.yellow),
                        Text(
                          rating,
                          style: TextStyle(
                            color: const Color.fromARGB(170, 255, 255, 255),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        overview == '' ? 'no description available' : overview,
                        softWrap: true,
                        // maxLines: null,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
