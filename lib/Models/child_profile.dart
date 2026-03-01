class ChildProfile {
  final String id;
  final String name;
  final String avatar;

  ChildProfile({required this.id, required this.name, required this.avatar});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
      };

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        id: json['id'] as String,
        name: json['name'] as String,
        avatar: json['avatar'] as String,
      );

  ChildProfile copyWith({String? name, String? avatar}) => ChildProfile(
        id: id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );
}
