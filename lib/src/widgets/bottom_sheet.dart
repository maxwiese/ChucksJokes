import 'package:chucks_jokes/src/data/joke.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryBottomSheet extends StatelessWidget {
  final Function onSelect;

  CategoryBottomSheet({@required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView(
        children: JokeCategory.values
            .map(
              (e) => CategoryItemTile(
                category: e,
                onTap: () {this.onSelect(e); Navigator.pop(context);},
              ),
            )
            .toList(),
      ),
    );
  }
}

class CategoryItemTile extends StatelessWidget {
  final JokeCategory category;
  final VoidCallback onTap;

  CategoryItemTile({this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: GestureDetector(
          onTap: this.onTap,
          child: Card(
            elevation: 8.0,
            color: Theme.of(context).backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${describeEnum(category)}',
                  //style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
