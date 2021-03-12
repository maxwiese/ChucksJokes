import 'package:chucks_jokes/src/joke.dart';
import 'package:flutter/material.dart';

class JokeCard extends StatelessWidget {
  final Joke joke;

  const JokeCard({Key key, this.joke}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            joke.value,
            softWrap: true,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
    );
  }
}
