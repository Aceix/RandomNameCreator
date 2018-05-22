import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home:  new RandomWords(),
      theme: new ThemeData(
        primaryColor: Colors.white
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<WordPair> _saved = new Set<WordPair>();
    
  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('Welcome to Flutter'),
      actions: <Widget>[
        new IconButton(icon: new Icon(Icons.list), onPressed: () => _pushSaved())
      ],
      backgroundColor: Colors.blueGrey,
    ),
    body: _buildSuggestons()
  );

  void _pushSaved(){
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new SavedSuggetions(_saved);
        }
      )
    );
  }
  
  Widget _buildSuggestons(){
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i){
        if(i.isOdd)
          return new Divider();
        final index = i ~/ 2;
        if(index >= _suggestions.length)
          _suggestions.addAll(generateWordPairs(safeOnly: false).take(10));
        return _buildRow(_suggestions[index]);
      }
    );
  }
  
  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null
      ),
      onTap: (){
        setState((){
          if(alreadySaved)
            _saved.remove(pair);
          else
            _saved.add(pair);
        });
      }
    );
  }
}


// Saved suggstions Page
class SavedSuggetions extends StatefulWidget{
  final Set<WordPair> _savedWords;
  
  SavedSuggetions(Set<WordPair> sw):_savedWords = sw;

  @override
  createState() {
    return new SavedSuggetionsState(_savedWords);
  }
}

class SavedSuggetionsState extends State<SavedSuggetions>{
  Set<WordPair> _savedWords;
  final TextStyle _biggerFont = const TextStyle(fontSize: 20.0);
  
  // ctor
  SavedSuggetionsState(Set<WordPair> favList): _savedWords = favList;

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Saved Suggestions'),
        backgroundColor: Colors.teal
      ),
      body: _body()
    );
  }

  Widget _body(){
    final tiles = _savedWords.map(
      (pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.remove),
            onPressed: (){
              setState((){
                _savedWords.remove(pair);
              });
            }
          )
        );
      },
    );
    final divided = ListTile
      .divideTiles(
        context: context,
        tiles: tiles
      )
      .toList();
    
    return new ListView(children: divided);
  }
}
