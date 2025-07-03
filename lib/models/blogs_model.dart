class Blog {
  final String id;
  final String title;
  final String desc;
  final String author;
  final DateTime date;
  final int likes;
  final String imageUrl;

  Blog({
    required this.id,
    required this.title,
    required this.desc,
    required this.author,
    required this.date,
    required this.likes,
    required this.imageUrl,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] as String,
      title: json['title'] as String,
      desc: json['desc'] as String,
      author: json['author'] as String,
      date: DateTime.parse(json['date'] as String),
      likes: json['likes'] as int,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'author': author,
      'date': date.toIso8601String(),
      'likes': likes,
      'imageUrl': imageUrl,
    };
  }
}
