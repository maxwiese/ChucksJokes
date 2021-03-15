import 'package:chucks_jokes/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:chucks_jokes/src/bloc/bloc_provider.dart';
import 'package:chucks_jokes/src/bloc/joke_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: JokeBloc(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        darkTheme: ThemeData.dark(),
        home: Home(),
      ),
    );
  }
}