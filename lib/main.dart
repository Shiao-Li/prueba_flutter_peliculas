import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movies/api/endpoints.dart';
import 'package:movies/modal_class/function.dart';
import 'package:movies/modal_class/genres.dart';
import 'package:movies/modal_class/movie.dart';
import 'package:movies/screens/movie_detail.dart';
import 'package:movies/screens/search_view.dart';
import 'package:movies/screens/settings.dart';
import 'package:movies/screens/widgets.dart';
import 'package:movies/theme/theme_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAXSEJypPoBeClp6KR7AkKZSyiHljsP5F4',
      appId: '1:860116772302:web:d296ff7fb8a208555b779f',
      messagingSenderId: '860116772302',
      projectId: 'prueba2bim',
      authDomain: 'prueba2bim.firebaseapp.com',
      storageBucket: 'prueba2bim.appspot.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeState>(
      create: (_) => ThemeState(),
      child: MaterialApp(
        title: 'Matinee',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Colors.transparent,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          // Agrega otros delegados de localización que puedas necesitar
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es', 'ES'),
          // Agrega otros idiomas que desees admitir
        ],
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Genres> _genres = [];

  @override
  void initState() {
    super.initState();
    fetchGenres().then((value) {
      _genres = value.genres ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ThemeState>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: state.themeData.colorScheme.secondary,
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          'Matinee',
          style: state.themeData.textTheme.headlineSmall,
        ),
        backgroundColor: state.themeData.primaryColor,
        actions: <Widget>[
          IconButton(
            color: state.themeData.colorScheme.secondary,
            icon: Icon(Icons.search),
            onPressed: () async {
              final Movie? result = await showSearch<Movie?>(
                context: context,
                delegate:
                    MovieSearch(themeData: state.themeData, genres: _genres),
              );
              if (result != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailPage(
                      movie: result,
                      themeData: state.themeData,
                      genres: _genres,
                      heroId: '${result.id}search',
                    ),
                  ),
                );
              }
            },
          ),
          IconButton(
            color: state.themeData.colorScheme.secondary,
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SettingsPage(),
      ),
      body: Container(
        color: state.themeData.primaryColor,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            DiscoverMovies(
              themeData: state.themeData,
              genres: _genres,
            ),
            ScrollingMovies(
              themeData: state.themeData,
              title: 'Top Rated',
              api: Endpoints.topRatedUrl(1),
              genres: _genres,
            ),
            ScrollingMovies(
              themeData: state.themeData,
              title: 'Now Playing',
              api: Endpoints.nowPlayingMoviesUrl(1),
              genres: _genres,
            ),
            // ScrollingMovies(
            //   themeData: state.themeData,
            //   title: 'Upcoming Movies',
            //   api: Endpoints.upcomingMoviesUrl(1),
            //   genres: _genres,
            // ),
            ScrollingMovies(
              themeData: state.themeData,
              title: 'Popular',
              api: Endpoints.popularMoviesUrl(1),
              genres: _genres,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildLanguageButton(context, 'en', 'English'),
                _buildLanguageButton(context, 'es', 'Español'),
                // Agrega más botones para otros idiomas
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton(
      BuildContext context, String languageCode, String languageName) {
    return ElevatedButton(
      onPressed: () {
        _setLanguage(languageCode);
        Navigator.of(context).pop();
      },
      child: Text(languageName),
    );
  }

  Future<void> _setLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
  }
}
