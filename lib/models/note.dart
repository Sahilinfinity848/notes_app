class Note {
  final String id;
  String title;
  String body;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    final now = DateTime.now();
    final createdAtValue = json['createdAt'];
    final updatedAtValue = json['updatedAt'];
    final createdAt =
        createdAtValue is String && createdAtValue.isNotEmpty
            ? DateTime.parse(createdAtValue)
            : now;
    final updatedAt =
        updatedAtValue is String && updatedAtValue.isNotEmpty
            ? DateTime.parse(updatedAtValue)
            : createdAt;
    final savedId = json['id'];

    return Note(
      id:
          savedId is String && savedId.isNotEmpty
              ? savedId
              : now.microsecondsSinceEpoch.toString(),
      title: json['title']?.toString() ?? '',
      body: (json['body'] ?? json['description'])?.toString() ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
