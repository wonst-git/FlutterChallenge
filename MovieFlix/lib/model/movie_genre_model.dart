class MovieGenreModel {
  final int id;
  final String name;

  MovieGenreModel({required this.id, required this.name});

  MovieGenreModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  @override
  String toString() => 'id: $id, name: $name';
}
