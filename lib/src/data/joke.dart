import 'dart:core';

enum JokeCategory {
  random,
  animal,
  career,
  celebrity,
  dev,
  explicit,
  fashion,
  food,
  history,
  money,
  movie,
  music,
  political,
  religion,
  science,
  sport,
  travel
}

class Joke {
  final String iconUrl;
  final String id;
  final String url;
  final String value;
  final List<JokeCategory> categories;
  final String createdAt;
  final String updatedAt;

  Joke({
    this.iconUrl,
    this.id,
    this.url,
    this.value,
    this.categories,
    this.createdAt,
    this.updatedAt,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    // TODO: implement categories
    return Joke(
      iconUrl: json['icon_url'],
      id: json['id'],
      url: json['url'],
      value: json['value'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}