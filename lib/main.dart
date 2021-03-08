import 'dart:async';
import 'package:flutter/material.dart';
import 'musique.dart';
import 'package:audioplayer2/audioplayer2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music app',
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Music app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /* ------------- VARIABLES */
  // --
  AudioPlayer playerAudio;
  Duration position = new Duration(seconds: 0);
  // ignore: cancel_subscriptions
  StreamSubscription positionSub;
  // ignore: cancel_subscriptions
  StreamSubscription stateSubscription;
  Duration duree = new Duration(seconds: 0);
  PlayerState statut = PlayerState.stopped;
  int index = 0;
  // --
  List<Music> maListeDeMusique = [
    new Music("theme Swift", "codabee", "assets/un.jpg",
        "https://codabee.com/wp-content/uploads/2018/06/deux.mp3"),
    new Music("data", "bur", "assets/deux.png",
        "https://codabee.com/wp-content/uploads/2018/06/un.mp3"),
  ];

  // --
  Music maMusiqueActuelle;
  /* ------------- FIN VARIABLES */

  /* --- METHODES -------------- */
  Text textSlide(String data) {
    return new Text(
      data,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Colors.blueGrey,
        fontStyle: FontStyle.italic,
        fontSize: 15.0,
      ),
    );
  }

  IconButton bouton(IconData iconeData, double sizerT, ActionMusic action) {
    return new IconButton(
      iconSize: sizerT,
      color: Colors.blueAccent,
      icon: new Icon(iconeData),
      onPressed: () {
        switch (action) {
          case ActionMusic.play:
            play();
            break;
          case ActionMusic.pause:
            pause();
            break;
          case ActionMusic.forward:
            forward();
            break;
          case ActionMusic.rewind:
            rewind();
            break;
          default:
            print("default");
            break;
        }
      },
    );
  }

  // --
  Padding paddingText(String data, double taille) {
    return new Padding(
      padding: EdgeInsets.all(taille),
      child: Text(
        data,
        style: new TextStyle(
          fontSize: 20.0,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  // -- config audio
  void configurationAudio() {
    playerAudio = new AudioPlayer();
    positionSub = playerAudio.onAudioPositionChanged.listen(
      (event) => setState(() => position = event),
    );

    stateSubscription = playerAudio.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.PLAYING) {
        setState(() {
          duree = playerAudio.duration;
        });
      } else if (state == AudioPlayerState.STOPPED) {
        setState(() {
          statut = PlayerState.stopped;
        });
      }
    }, onError: (message) {
      print('erreur : $message');
      setState(() {
        statut = PlayerState.stopped;
        duree = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  // --
  Future play() async {
    await playerAudio.play(maMusiqueActuelle.urlSong);
    setState(() {
      statut = PlayerState.playing;
    });
  }

  // --
  Future pause() async {
    await playerAudio.pause();
    setState(() {
      statut = PlayerState.paused;
    });
  }

  // --
  void forward() {
    if (index == maListeDeMusique.length - 1) {
      index = 0;
    } else {
      index++;
    }
    maMusiqueActuelle = maListeDeMusique[index];
    playerAudio.stop();
    configurationAudio();
    play();
  }

  void rewind() {
    if (position > Duration(seconds: 3)) {
      playerAudio.seek(0.0); // revenir au debut de la musique
    } else {
      if (index == 0) {
        index = maListeDeMusique.length - 1;
      } else {
        index--;
      }
      maMusiqueActuelle = maListeDeMusique[index];
      playerAudio.stop();
      configurationAudio();
      play();
    }
  }

  String timeMusic(Duration duree) {
    return duree.toString().split('.').first;
  }

  /* --- fin METHODES ---------- */
  // --
  /* quand l'etat va etre initialisé */
  @override
  void initState() {
    super.initState();
    maMusiqueActuelle = maListeDeMusique[index];
    configurationAudio();
  }

  @override
  Widget build(BuildContext context) {
    /* --------------- SCAFFOLD  ---------------- */
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("AppMusic"),
        backgroundColor: Colors.blueAccent,
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            /* --- card qui contient l'image à afficher -- */
            new Card(
              elevation: 5.0,
              child: new Container(
                width: MediaQuery.of(context).size.height / 2.5,
                color: Colors.lightBlue,
                height: MediaQuery.of(context).size.height / 2.5,
                child: new Image.asset(maMusiqueActuelle.imagePath),
              ),
            ),

            /* -- paddingText -- */
            paddingText(maMusiqueActuelle.artiste, 7.3),
            paddingText(maMusiqueActuelle.titre, 2.0),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bouton(Icons.fast_rewind_rounded, 30.0, ActionMusic.rewind),
                bouton(
                    (statut == PlayerState.playing)
                        ? Icons.pause
                        : Icons.play_arrow_rounded,
                    50.0,
                    (statut == PlayerState.playing)
                        ? ActionMusic.pause
                        : ActionMusic.play),
                bouton(Icons.fast_forward_rounded, 30.0, ActionMusic.forward),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                textSlide(timeMusic(position)),
                textSlide(timeMusic(duree)),
              ],
            ),
            new Slider(
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: 30.0,
              inactiveColor: Colors.grey,
              activeColor: Colors.blue,
              onChanged: (double d) {
                /* la position du curseur de slider sera = d */
                setState(() {
                  playerAudio.seek(d);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

// enum pour differencier les boutons
enum ActionMusic { play, pause, rewind, forward }
// état de mon audio player
enum PlayerState { playing, stopped, paused }
