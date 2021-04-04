import 'package:flutter/material.dart';

class MovieBlock extends StatelessWidget {
  final movie;
  final cfgs;

  MovieBlock(this.movie, this.cfgs);

  Widget build(BuildContext context) {
    String mediaTitle = '';
    String imageUrl = '';
    var voteAverage;

    voteAverage = movie['vote_average'];
    mediaTitle = movie["title"];

    if (movie["poster_path"] != null) {
      imageUrl =
          cfgs['base_url'] + cfgs['poster_sizes'][4] + movie["poster_path"];
    } else {
      imageUrl =
          'https://motivatevalmorgan.com/wp-content/uploads/2016/06/default-movie-1-3.jpg';
    }

    return new Column(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Image.network(imageUrl),
              new Container(
                height: 8.0,
              ),
              new Text(
                mediaTitle,
                style:
                    new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
                    text: ' ' + voteAverage.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(1)))
              ]))
            ],
          ),
        ),
        new Divider()
      ],
    );
  }
}
