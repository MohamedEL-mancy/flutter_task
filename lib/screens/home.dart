import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/helper/movies_provider.dart';
import 'package:movies/model/movies_model.dart';
import 'package:movies/screens/details.dart';
import 'package:movies/styles/grid_styles.dart';
import 'package:movies/styles/list_styles.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool view = true;
  List _search = [];

  Future<Null> refreshList() async {
    await Future.delayed(Duration(milliseconds: 1000));
  }

  var controllerEnd = ScrollController();
  Widget _loading() {
    return CircularProgressIndicator();
  }

  @override
  void initState() {
    controllerEnd.addListener(() {
      if (controllerEnd.position.pixels ==
          controllerEnd.position.maxScrollExtent) {
        print("No Others");
        _loading();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Movies>(context);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Movies",
          style: titleListStyle,
        ),
        actions: [
          FlatButton(
            onPressed: () {
              setState(() {
                view = false;
              });
            },
            child: Text("Grid Show"),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                view = true;
              });
            },
            child: Text("List Show"),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
              )
            ]),
            child: TextFormField(
              onChanged: (text) {
                _search.clear();
                data.movieList.forEach((element) {
                  if (element.title.contains(text) ||
                      element.id.toString().contains(text)) {
                    _search.add(element);
                    if (text == "") {
                      _search.clear();
                    }
                    setState(() {});

                    print(text);
                  }
                });
                print(_search);
              },
              autocorrect: false,
              decoration: InputDecoration(
                hintText: "Search Movie",
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true,
                suffixIcon: Icon(
                  Icons.search,
                  size: 30.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          view
              ? Expanded(
                  child: _search.length != 0
                      ? FutureBuilder(
                          future: data.getMovies(),
                          builder: (context,
                              AsyncSnapshot<List<MovieModel>> snapshot) {
                            var movie = snapshot.data;
                            if (movie == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return ListView.builder(
                                controller: controllerEnd,
                                physics: BouncingScrollPhysics(),
                                itemCount: _search.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == _search.length) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MovieDetails(
                                              movieId: movie[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 20.0),
                                            width: double.infinity,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              elevation: 15.0,
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 30.0),
                                                margin: EdgeInsets.only(
                                                    left: 120.0, right: 10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _search[index].title,
                                                      style: titleListStyle,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        RatingBar(
                                                          onRatingUpdate:
                                                              (rate) {
                                                            print(rate);
                                                          },
                                                          ignoreGestures: true,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemSize: 25.0,
                                                          initialRating:
                                                              movie[index]
                                                                      .rate /
                                                                  2,
                                                          unratedColor:
                                                              Colors.grey,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.yellow,
                                                            );
                                                          },
                                                        ),
                                                        Text(
                                                          movie[index]
                                                              .rate
                                                              .toString(),
                                                          style:
                                                              ratingListStyle,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.0),
                                                    Text(
                                                      movie[index].description,
                                                      maxLines: 3,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 15.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: FadeInImage.memoryNetwork(
                                                  placeholder:
                                                      kTransparentImage,
                                                  image: movie[index].image,
                                                  height: height * 0.2,
                                                  width: width * 0.25,
                                                  imageErrorBuilder:
                                                      (context, object, error) {
                                                    return Image.network(
                                                      "https://www.pngitem.com/pimgs/m/561-5616833_image-not-found-png-not-found-404-png.png",
                                                      height: height * 0.2,
                                                      width: width * 0.25,
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        )
                      : FutureBuilder(
                          future: data.getMovies(),
                          builder: (context,
                              AsyncSnapshot<List<MovieModel>> snapshot) {
                            var movie = snapshot.data;
                            if (movie == null) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return RefreshIndicator(
                              onRefresh: refreshList,
                              child: ListView.builder(
                                  controller: controllerEnd,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: 15 + 1,
                                  itemBuilder: (context, index) {
                                    if (index == 15) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    return Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetails(
                                                movieId: movie[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(top: 20.0),
                                              width: double.infinity,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                elevation: 15.0,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      bottom: 30.0),
                                                  margin: EdgeInsets.only(
                                                      left: 120.0, right: 10.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        movie[index].title,
                                                        style: titleListStyle,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          RatingBar(
                                                            onRatingUpdate:
                                                                (rate) {
                                                              print(rate);
                                                            },
                                                            ignoreGestures:
                                                                true,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            itemSize: 25.0,
                                                            initialRating:
                                                                movie[index]
                                                                        .rate /
                                                                    2,
                                                            unratedColor:
                                                                Colors.grey,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .yellow,
                                                              );
                                                            },
                                                          ),
                                                          Text(
                                                            movie[index]
                                                                .rate
                                                                .toString(),
                                                            style:
                                                                ratingListStyle,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10.0),
                                                      Text(
                                                        movie[index]
                                                            .description,
                                                        maxLines: 3,
                                                        textDirection:
                                                            TextDirection.ltr,
                                                        textAlign:
                                                            TextAlign.start,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 15.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                child: Hero(
                                                  tag: movie[index].id,
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                          placeholder:
                                                              kTransparentImage,
                                                          image: movie[index]
                                                              .image,
                                                          height: height * 0.15,
                                                          width: width * 0.25,
                                                          imageErrorBuilder:
                                                              (context, object,
                                                                  error) {
                                                            return Image
                                                                .network(
                                                              "https://www.pngitem.com/pimgs/m/561-5616833_image-not-found-png-not-found-404-png.png",
                                                              height:
                                                                  height * 0.2,
                                                              width:
                                                                  width * 0.25,
                                                            );
                                                          }),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          },
                        ),
                )
              : FutureBuilder(
                  future: data.getMovies(),
                  builder: (context, AsyncSnapshot<List<MovieModel>> snapshot) {
                    var movie = snapshot.data;
                    if (movie == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Expanded(
                      child: GridView.builder(
                        controller: controllerEnd,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 20.0,
                        ),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetails(
                                    movieId: movie[index].id,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Hero(
                                    tag: movie[index].id,
                                    child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: movie[index].image,
                                        height: height * 0.15,
                                        //width: width * 0.25,
                                        fit: BoxFit.fill,
                                        imageErrorBuilder:
                                            (context, object, error) {
                                          return Image.network(
                                            "https://www.pngitem.com/pimgs/m/561-5616833_image-not-found-png-not-found-404-png.png",
                                            height: height * 0.2,
                                            width: width * 0.25,
                                          );
                                        }),
                                  ),
                                ),
                                Expanded(
                                  child: Text(movie[index].title,
                                      style: titleGridStyle,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        movie[index].rate.toString(),
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
