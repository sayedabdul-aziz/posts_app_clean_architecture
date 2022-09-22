import 'package:posts_app_clean_architecture/features/posts/domain/entities/post.dart';

class PostModel extends Post {
  final int id;
  final String title;
  final String body;
  PostModel({required this.id, required this.title, required this.body})
      : super(id, title, body);

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(id: json['id'], title: json['title'], body: json['body']);
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'body': body};
  }
}
