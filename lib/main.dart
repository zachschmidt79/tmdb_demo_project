import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './movie_block.dart';
import './movie_page.dart';
import './actor_cardlist.dart';
import './colorscheme.dart';

void main() {
  runApp(new MovieApp());
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TMDB Demo',
      theme: new ThemeData(primarySwatch: colorCustom),
      home: new MovieAppHome(),
    );
  }
}

class MovieAppHome extends StatefulWidget {
  @override
  _MovieAppHomeState createState() => new _MovieAppHomeState();
}

class _MovieAppHomeState extends State<MovieAppHome> {
  SearchBar searchBar;
  var movies;
  var cfg;

  bool loading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Image(image: AssetImage('images/tmdb_main_logo.png')),
        actions: [searchBar.getSearchAction(context)]);
  }

  onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState);
    //print('$value');
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new SearchResultsST(searchvalue: value)));
    return SearchResultsST(searchvalue: value);
  }

  _MovieAppHomeState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  _getTrending() async {
    print("Attempting to fetch trending data from network");
    final url =
        'https://api.themoviedb.org/3/trending/movie/day?api_key=d54e25b11a099fa81dba4c52daabb377';
    final response = await http.get(url);

    final config =
        'https://api.themoviedb.org/3/configuration?api_key=d54e25b11a099fa81dba4c52daabb377';
    final cfgResponse = await http.get(config);

    if (response.statusCode == 200) {
      //print(response.body);

      final map = json.decode(response.body);
      final moviesJson = map["results"];

      final cfgmap = json.decode(cfgResponse.body);
      final cfgJson = cfgmap["images"];

      setState(() {
        this.movies = moviesJson;
        this.cfg = cfgJson;

        loading = false;
      });
    }
  }

  void initState() {
    super.initState();
    _getTrending();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return new Scaffold(
        backgroundColor: colorCustom2,
        appBar: new AppBar(
            title: new Image(image: AssetImage('images/tmdb_main_logo.png'))),
        body: new Center(child: new CircularProgressIndicator()),
      );
    return new Scaffold(
      backgroundColor: colorCustom2,
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: new Center(
        child: new ListView.builder(
          itemCount: this.movies != null ? this.movies.length : 0,
          itemBuilder: (context, i) {
            final movie = this.movies[i];
            return new FlatButton(
              padding: new EdgeInsets.all(0.0),
              child: new MovieBlock(movie, cfg),
              onPressed: () {
                print('Tapped $i');
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            new DetailPage(id: this.movies[i]['id'])));
              },
            );
          },
        ),
      ),
    );
  }
}

class SearchResultsST extends StatefulWidget {
  final String searchvalue;
  SearchResultsST({Key key, @required this.searchvalue}) : super(key: key);

  _SearchResultsSTState createState() => _SearchResultsSTState();
}

class _SearchResultsSTState extends State<SearchResultsST> {
  var movies;
  var cfg;

  bool loading = true;

  _searchData(String searchvalue) async {
    print("Attempting to fetch search data from network");

    String query = searchvalue
        .replaceAll(' ', '%20')
        .replaceAll(':', '%3A')
        .replaceAll(',', '%2C')
        .replaceAll('\'', '%27')
        .replaceAll('!', '%21');
    final url =
        "https://api.themoviedb.org/3/search/movie?api_key=d54e25b11a099fa81dba4c52daabb377&language=en-US&query=" +
            query +
            "&include_adult=false";
    final response = await http.get(url);

    final config =
        'https://api.themoviedb.org/3/configuration?api_key=d54e25b11a099fa81dba4c52daabb377';
    final cfgResponse = await http.get(config);

    if (response.statusCode == 200) {
      //print(response.body);
      //print(searchvalue);

      final map = json.decode(response.body);
      final moviesJson = map["results"];

      final cfgmap = json.decode(cfgResponse.body);
      final cfgJson = cfgmap["images"];

      setState(() {
        this.movies = moviesJson;
        this.cfg = cfgJson;

        loading = false;
      });
    }
  }

  void initState() {
    super.initState();
    _searchData(widget.searchvalue);
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return new Scaffold(
        backgroundColor: colorCustom2,
        appBar: new AppBar(title: new Text("Loading...")),
        body: new Center(child: new CircularProgressIndicator()),
      );
    return new Scaffold(
      backgroundColor: colorCustom2,
      appBar: new AppBar(title: new Text("Results for: " + widget.searchvalue)),
      body: new Center(
        child: new ListView.builder(
          itemCount: this.movies != null ? this.movies.length : 0,
          itemBuilder: (context, i) {
            final movie = this.movies[i];
            return new FlatButton(
              padding: new EdgeInsets.all(0.0),
              child: new MovieBlock(movie, cfg),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            new DetailPage(id: this.movies[i]['id'])));
              },
            );
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  final int id;
  DetailPage({Key key, @required this.id}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var movieresult;
  var cfg;
  var cast;

  bool loading = true;

  _getDetails(int id) async {
    print("Attempting to fetch movie details from network.");

    final url = 'https://api.themoviedb.org/3/movie/' +
        id.toString() +
        '?api_key=d54e25b11a099fa81dba4c52daabb377&language=en-US';

    final response = await http.get(url);

    final castUrl = 'https://api.themoviedb.org/3/movie/' +
        id.toString() +
        '/credits?api_key=d54e25b11a099fa81dba4c52daabb377&language=en-US';

    final castResponse = await http.get(castUrl);

    final config =
        'https://api.themoviedb.org/3/configuration?api_key=d54e25b11a099fa81dba4c52daabb377';

    final cfgResponse = await http.get(config);

    if (response.statusCode == 200) {
      //print(response.body);
      //print(searchvalue);

      final movieresultsJson = json.decode(response.body);
      //final movieresultsJson = map[""];

      final castMap = json.decode(castResponse.body);
      final castJson = castMap["cast"];

      final cfgmap = json.decode(cfgResponse.body);
      final cfgJson = cfgmap["images"];

      setState(() {
        this.movieresult = movieresultsJson;
        this.cast = castJson;
        this.cfg = cfgJson;
        loading = false;
      });
    }
  }

  void initState() {
    super.initState();
    _getDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return new Scaffold(
        backgroundColor: colorCustom2,
        appBar: new AppBar(title: new Text("Loading...")),
        body: new Center(child: new CircularProgressIndicator()),
      );
    return new Scaffold(
      backgroundColor: colorCustom2,
      appBar: new AppBar(title: new Text(this.movieresult["title"])),
      body: new Center(
        child: ListView(padding: new EdgeInsets.all(16.0), children: <Widget>[
          new MoviePage(this.movieresult, this.cfg),
          new Text('Cast',
              style:
                  new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          SizedBox(
              height: 400,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      childAspectRatio: 16 / 9.2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: this.cast != null ? this.cast.length : 0,
                  itemBuilder: (context, i) {
                    final cast = this.cast[i];
                    return new Card(
                        color: colorCustom3, child: new ActorList(cast, cfg));
                  }))
        ]),
      ),
    );
  }
}
