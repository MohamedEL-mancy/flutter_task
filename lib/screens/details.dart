import 'package:flutter/material.dart';
import 'package:movies/helper/movies_provider.dart';
import 'package:movies/model/movies_model.dart';
import 'package:movies/styles/details_style.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieDetails extends StatefulWidget {
  static String id = "Details";
  final int movieId;
  MovieDetails({this.movieId});
  @override
  MovieDetailsState createState() => MovieDetailsState();
}

class MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var data = Provider.of<Movies>(context);
    return Scaffold(
      body: FutureBuilder(
        future: data.getMovieDetails(id: widget.movieId),
        builder: (context, AsyncSnapshot<MovieModel> snaphot) {
          var movie = snaphot.data;
          if (movie == null) {
            return Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ShaderMask(
                        shaderCallback: (rec) => LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.4),
                                Colors.white,
                              ],
                            ).createShader(rec),
                        child: Hero(
                          tag: widget.movieId,
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: movie.image,
                              height: height * 0.5,
                              fit: BoxFit.fill,
                              width: double.infinity,
                              imageErrorBuilder: (context, object, error) {
                                return Image.network(
                                  "https://www.pngitem.com/pimgs/m/561-5616833_image-not-found-png-not-found-404-png.png",
                                  height: height * 0.2,
                                  width: width * 0.25,
                                );
                              }),
                        )),
                    Positioned(
                      top: 20.0,
                      left: 10.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 270.0,
                      left: 20.0,
                      child: Row(
                        children: [
                          Text(
                            movie.title,
                            style: titleDetailsStyle,
                          ),
                          Stack(
                            children: [
                              Icon(
                                Icons.bookmark,
                                color: Colors.red,
                                size: 40.0,
                              ),
                              Positioned(
                                top: 10.0,
                                left: 10.0,
                                child: Text(
                                  "7.7",
                                  style: rateDetailsStyle,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: titleDetailsStyle.copyWith(fontSize: 20.0),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        movie.description ??
                            "Data Here Not Avaialabe On the Server",
                        maxLines: 6,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: descriptionDetailsStyle,
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Genres",
                        style: titleDetailsStyle.copyWith(fontSize: 20.0),
                      ),
                      Container(
                        height: height * 0.1,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movie.genres.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15.0),
                                    ),
                                  ),
                                  child: Text(
                                    movie.genres[index],
                                    style: genresDetailsStyle,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
