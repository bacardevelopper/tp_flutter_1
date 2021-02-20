import 'package:flutter/material.dart';

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
  Color couleur = Colors.pinkAccent;
  /* ------------- FIN VARIABLES */

  /* --- METHODES -- */
  IconButton bouton(IconData iconeData, double sizerT) {
    return new IconButton(
      iconSize: sizerT,
      color: Colors.blueAccent,
      icon: new Icon(iconeData),
      onPressed: () {},
    );
  }

  Padding paddingText(String data, double taille) {
    return new Padding(
      padding: EdgeInsets.all(taille),
      child: Text(
        data,
        style: new TextStyle(fontSize: 20.0, color: couleur),
      ),
    );
  }

  /* --- fin METHODES-- */
  @override
  Widget build(BuildContext context) {
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
              elevation: 9.0,
              child: new Container(
                width: MediaQuery.of(context).size.height / 2.5,
                color: Colors.lightBlue,
                height: MediaQuery.of(context).size.height / 2.5,
              ),
            ),
            /* -- paddingText -- */

            paddingText('Titre music', 7.3),
            paddingText('Titre music', 2.0),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bouton(Icons.fast_rewind_rounded, 30.0),
                bouton(Icons.play_arrow_rounded, 50.0),
                bouton(Icons.fast_forward_rounded, 30.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
