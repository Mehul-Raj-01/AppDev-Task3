import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../movie_desc.dart';

class CardViewer extends StatelessWidget {
  final String url;
  final String movieName;
  final String rating;
  final String duration;
  final int id;

  const CardViewer({
    super.key,
    required this.url,
    required this.movieName,
    required this.rating,
    required this.duration,
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
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 120,
          height: 215,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 24, 23, 27),
            borderRadius: BorderRadius.circular(8),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    (context, url, error) => const Icon(Icons.error_outline),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  movieName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),

              Row(
                children: [
                  Text(
                    duration,
                    style: TextStyle(
                      color: const Color.fromARGB(170, 255, 255, 255),
                      fontSize: 12,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.star, size: 14, color: Colors.yellow),
                  Text(
                    rating,
                    style: TextStyle(
                      color: const Color.fromARGB(170, 255, 255, 255),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
