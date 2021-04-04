import 'package:flutter/material.dart';

class MoviePage extends StatelessWidget {
  final movieresult;
  final cfgs;

  MoviePage(this.movieresult, this.cfgs);

  Widget build(BuildContext context) {
    String mediaTitle = '';
    String overviewDescription = '';
    String releaseDate = '';
    String imageUrl = '';
    var voteAverage;
    int voteCount = 0;

    mediaTitle = movieresult['title'];
    releaseDate = movieresult['release_date'];
    overviewDescription = movieresult['overview'];
    voteCount = movieresult['vote_count'];
    voteAverage = movieresult['vote_average'];

    if (movieresult["poster_path"] != null) {
      imageUrl = cfgs['base_url'] +
          cfgs['poster_sizes'][4] +
          movieresult["poster_path"];
    } else {
      imageUrl =
          'https://motivatevalmorgan.com/wp-content/uploads/2016/06/default-movie-1-3.jpg';
    }

    return new Column(children: <Widget>[
      new Container(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Image.network(imageUrl),
            new Container(
              height: 8.0,
            ),
            new Text(
              mediaTitle,
              style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            new RichText(
                text: TextSpan(children: [
              WidgetSpan(
                  child: Icon(
                Icons.star,
                size: 18,
                color: Colors.yellow,
              )),
              TextSpan(
                  text: ' ' +
                      voteAverage.toString() +
                      ' - Votes: ' +
                      voteCount.toString() +
                      ' - Released: ' +
                      releaseDate,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.black.withOpacity(1)))
            ])),
            new Text(
              overviewDescription,
              style: new TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    ]);
  }
}
