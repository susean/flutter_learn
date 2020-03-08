import 'userManage/login.dart';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final wordPair = new WordPair.random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '使用第三方包示例',
      theme: new ThemeData(
        primaryColor: Colors.blue
      ),
      home: new LoginWidget(),
      /*Scaffold(
          appBar: AppBar(
            title: Text('使用第三方包示例'),
          ),
          body: new Center(
            child: new RandomWords(),
          )
          */ /*new Center(
          child: new RaisedButton(
              onPressed: _httpClientTest, child: Text('open the url')),
        ),*/ /*
          ),*/
    );
  }
}

