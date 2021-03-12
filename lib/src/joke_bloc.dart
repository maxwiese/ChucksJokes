import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:chucks_jokes/src/joke.dart';

class JokeApiException implements Exception {
  String cause;
  JokeApiException(this.cause);

  @override
  String toString() {
    return this.cause;
  }
}

enum ButtonAction { next, previous }

class JokeBloc {
  Stream<Joke> get joke => _jokeSubject.stream;
  final _jokeSubject = BehaviorSubject<Joke>();

  StreamSink<ButtonAction> get control => _controlController.sink;
  final _controlController = StreamController<ButtonAction>();

  List<String> history = [];

  JokeBloc() {
    _newJoke();

    _controlController.stream.listen((event) {
      if (event == ButtonAction.next) {
        _newJoke();
      } else {
        _previousJoke();
      }
    });
  }

  void _newJoke() async {
    Joke joke = await _getRandomJoke();
    history.add(joke.id);
    _jokeSubject.add(joke);
  }

  void _previousJoke() async {
    if (history.isEmpty || history.length == 1) return;

    history.removeLast();
    final String lastId = history.last;

    Joke joke = await _getJoke(lastId);
    _jokeSubject.add(joke);
  }

  Future<Joke> _getRandomJoke({JokeCategory category}) async {
    final base = "api.chucknorris.io";
    final path = "/jokes/random";

    Uri url = Uri.https(base, path);

    if (category != null)
      url = Uri.https(base, path, {'categroy': '$category'});

    final response = await http.get(url);

    if (response.statusCode != 200)
      throw JokeApiException('Cannot fetch the joke');

    return Joke.fromJson(json.decode(response.body));
  }

  Future<Joke> _getJoke(String id) async {
    final base = "api.chucknorris.io";
    final path = "/jokes/$id";

    Uri url = Uri.https(base, path);

    final response = await http.get(url);

    if (response.statusCode != 200)
      throw JokeApiException('Cannot fetch the joke');

    return Joke.fromJson(json.decode(response.body));
  }
}
