class Topic {
  final String id;
  final String name;
  final String slug;
  final String color;
  final int order;

  Topic({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.order,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      color: json['color']?.toString().trim() ?? '#000000',
      order: json['order'] ?? 0,
    );
  }
}
