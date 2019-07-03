import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tutorial_http_request/Photo.dart';
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Future<List<Photo>> fetchPhoto() async {
  final response =
      await http.get("https://jsonplaceholder.typicode.com/photos");
  print(response.body);
  return compute(parsePhotos, response.body);
}

List<Photo> parsePhotos(String body) {
  final parsed = json.decode(body).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<List<Photo>>(
          future: fetchPhoto(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? PhotoList(photos: snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class PhotoList extends StatelessWidget {
  final List<Photo> photos;

  PhotoList({this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            Image.network(photos[index].thumbnailUrl),
            Text(photos[index].title)
          ],
        );
      },
    );
  }
}
