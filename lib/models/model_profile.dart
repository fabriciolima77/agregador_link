
class Profile {
  String id;
  final String title;
  final String subtitle;
  final String profileImage;

  Profile({
    this.id = '',
    required this.title,
    required this.subtitle,
    required this.profileImage,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subtitle': subtitle,
    'image': profileImage,
  };

  static Profile fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'],
    title: json['title'],
    subtitle: json['subTitle'],
    profileImage: json['profileImage'],
  );
}