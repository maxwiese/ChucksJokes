import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'package:chucks_jokes/src/bloc/bloc.dart';
import 'package:chucks_jokes/src/data/joke.dart';

class JokeApiException implements Exception {
  String cause;
  JokeApiException(this.cause);

  @override
  String toString() {
    return this.cause;
  }
}

enum ButtonAction { next, previous }

enum CategorySelector { select }

class JokeBloc implements Bloc {
  final _jokeSubject = BehaviorSubject<Joke>();
  Stream<Joke> get joke => _jokeSubject.stream;

  final _jokeCategorySubject = BehaviorSubject<JokeCategory>();
  Stream<JokeCategory> get jokeCategory => _jokeCategorySubject.stream;

  final _controlController = StreamController<ButtonAction>();
  StreamSink<ButtonAction> get control => _controlController.sink;

  final _categoryController = StreamController<JokeCategory>();
  StreamSink<JokeCategory> get selectCategory => _categoryController.sink;

  List<String> _history = [];
  JokeCategory _category = JokeCategory.random;

  JokeBloc() {
    _newJoke(category: _category);

    _controlController.stream.listen((event) {
      if (event == ButtonAction.next) {
        _newJoke(category: _category);
      } else {
        _previousJoke();
      }
    });

    _categoryController.stream.listen((event) {
      _category = event;
      _newJoke(category: _category);
    });
  }

  void _newJoke({JokeCategory category}) async {
    Joke joke = await _getRandomJoke(category: _category);
    _history.add(joke.id);
    _jokeSubject.add(joke);
    _jokeCategorySubject.add(_category);
  }

  void _previousJoke() async {
    if (_history.isEmpty || _history.length == 1) return;

    _history.removeLast();
    final String lastId = _history.last;

    Joke joke = await _getJoke(lastId);
    _jokeSubject.add(joke);
    _jokeCategorySubject.add(_category);
  }

  Future<Joke> _getRandomJoke({JokeCategory category}) async {
    final base = "api.chucknorris.io";
    final path = "/jokes/random";

    Uri url = Uri.https(base, path);

    if (category != JokeCategory.random)
      url = Uri.https(base, path, {'category': '${describeEnum(category)}'});

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

  @override
  void dispose() {
    _controlController.close();
    _categoryController.close();
  }
}
