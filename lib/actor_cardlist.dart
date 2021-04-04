import 'package:flutter/material.dart';

class ActorList extends StatelessWidget {
  final cfgs;
  final cast;

  ActorList(this.cast, this.cfgs);

  Widget build(BuildContext context) {
    String actorName = '';
    String actorImage = '';
    String character = '';

    actorName = cast['name'];
    actorImage = cast['profile_path'];
    character = cast['character'];

    if (cast["profile_path"] != null) {
      actorImage =
          cfgs['base_url'] + cfgs['poster_sizes'][4] + cast["profile_path"];
    } else {
      actorImage = 'https://i.imgur.com/1MYWiv1.png';
    }

    //To display Actor Cards on movie page.
    return new Column(children: [
      new Text(actorName, style: new TextStyle(fontSize: 14.0)),
      new Image.network(actorImage),
      new Text(character, style: new TextStyle(fontSize: 14.0))
    ]);
  }
}
