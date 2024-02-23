
class Button {
  String id;
  final String title;
  final String image;
  final String url;
  final bool isActive;

  Button({
    this.id = '',
    required this.title,
    required this.image,
    required this.url,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'url': url,
    'isActive': isActive,
  };

  static Button fromJson(Map<String, dynamic> json) => Button(
    id: json['id'],
    title: json['title'],
    image: json['image'],
    url: json['url'],
    isActive: json['isActive'],
  );
}