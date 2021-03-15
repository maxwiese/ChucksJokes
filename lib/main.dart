import 'package:chucks_jokes/src/bloc/bloc_provider.dart';
import 'package:chucks_jokes/src/data/joke.dart';
import 'package:chucks_jokes/src/widgets/joke_card.dart';
import 'package:flutter/material.dart';

import 'package:chucks_jokes/src/bloc/joke_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: JokeBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        darkTheme: ThemeData.dark(),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        title: Text('Chucks Jokes'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder<Joke>(
              stream: BlocProvider.of<JokeBloc>(context).joke,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitFadingCube(
                        color: Theme.of(context).accentColor,
                        size: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Text(
                          'Fetching jokes',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  );

                return Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: JokeCard(
                    joke: snapshot.data,
                  ),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    BlocProvider.of<JokeBloc>(context).control.add(ButtonAction.previous);
                  }),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                  onPressed: () {
                    BlocProvider.of<JokeBloc>(context).control.add(ButtonAction.next);
                  })
            ],
          )
        ],
      ),
    );
  }
}
