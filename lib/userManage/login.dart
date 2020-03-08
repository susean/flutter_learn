import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_learn/bean/ResponseObjectUtils.dart' as ResponseO;
import 'package:flutter_app_learn/common/const.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<LoginWidget> {
  TextEditingController mobilePhoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool _isShow = false;
    _passwordShow() {
      _isShow = !_isShow;
//      passwordController.
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('欢迎登录'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.list), onPressed: null)
          ],
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextField(
              controller: mobilePhoneController,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: InputDecoration(
                hintText: '请输入手机号码',
                contentPadding: EdgeInsets.all(4.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.yellow, width: 2)),
                prefixIcon: Icon(Icons.person),
                helperText: '11位13-19开头的手机号码',
              ),
              autofocus: true,
              onChanged: _textFieldChanged,
            ),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isShow,
              maxLength: 16,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: '请输入密码',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
//                suffix: GestureDetector(
//                  onTap: _passwordShow,
//                  child: IconButton(
//                    icon: Icon(Icons.remove_red_eye),
//                    color: _isShow ? Colors.red : Colors.grey,
//                    onPressed: _passwordShow(),
//                  ),
//                ),
                contentPadding: EdgeInsets.all(4.0),
                prefixIcon: Icon(Icons.lock),
//                suffixIcon: IconButton(
//                  icon: Icon(Icons.remove_red_eye),
//                  onPressed: _passwordShow(),
//                ),
              suffix:  GestureDetector(
                onTap: _passwordShow,
                child: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  color: _isShow ? Colors.red : Colors.grey,
                  onPressed: _passwordShow(),
                ),
              ),
                helperText: '6-16位密码',
              ),
              autofocus: true,
              onChanged: _textFieldChanged,
            ),
            RaisedButton(
              onPressed: _login,
              child: Text('登录'),
            )
          ],
        ));
  }

  _login() {
    print({
      'mobilePhone ': mobilePhoneController.text,
      'password': passwordController.text
    });
//    _httpClientTest();
    _dioHttpRequet();
  }

  _textFieldChanged(String str) {
    print('看我的输出' + str);
  }

  _httpClientTest() async {
    try {
      var url = Const.normolUserLogin;
      Map jsonMap = {
        'mobilePhone': mobilePhoneController.text,
        'password': passwordController.text
      };
      print('传递的数据为\n' + (utf8.encode(json.encode(jsonMap)).toString()));
      HttpClient client = new HttpClient();
      var uri = new Uri.https('kuai5.rainhigh.cn', 'kUser/loginByMobilePhone', {
        'mobilePhone': mobilePhoneController.text,
        'password': passwordController.text
      });
      HttpClientRequest request = await client.postUrl(uri);
      HttpClientResponse response = await request.close();
      var result = await response.transform(utf8.decoder).join();
      print(result);
      client.close();
    } catch (e) {
      print(e.toString());
    } finally {
      print('执行最后的方法');
    }
  }

  void _dioHttpRequet() async {
    FormData jsonMap = FormData.fromMap({
      'mobilePhone': mobilePhoneController.text,
      'password': passwordController.text
    });

    try {
      Response response =
          await Dio().post(Const.normolUserLogin, data: jsonMap);
      Const.userInfo = response.data.toString();
      print('信息为：' + Const.userInfo);
      print('temp1:'+json.encode(response));
      Map<String,dynamic> map = jsonDecode(json.encode(response));

    } catch (e) {
      print(e.toString());
    }
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
//    final wordPair = new WordPair.random();
//    return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('你好，这是一个哦'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body:
//      new Image.network(        'https://developer.android.google.cn/topic/libraries/architecture/images/final-architecture.png',      ),
          _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();

          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
        title: new Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: new Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}

_launchURL() async {
  const url = 'https://www.baidu.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not open $url';
  }
}

_openAUrl() async {
  var url = 'https://kuai5.rainhigh.cn/swagger-ui.html';
  http.get(url).then((response) {
    print('状态为 : ' + response.statusCode.toString() + '\n' + response.body);
  });
}

_httpClientTest() async {
  try {
    var url = 'https://kuai5.rainhigh.cn/swagger-ui.html';
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    var result = await response.transform(utf8.decoder).join();
    print(result);
    client.close();
  } catch (e) {
    print(e.toString());
  } finally {
    print('执行最后的方法');
  }
}
