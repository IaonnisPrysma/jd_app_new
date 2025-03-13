import 'dart:convert';

class Event {
  String name;
  String description;
  DateTime dateTime;

  Event({
    required this.name,
    required this.description,
    required this.dateTime,
  });

  // Convert Event object to a Map for storing in local storage (e.g., SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dateTime': dateTime.toIso8601String(), // Store DateTime as ISO string
    };
  }

  // Create Event object from a Map (retrieved from local storage)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      dateTime: DateTime.parse(map['dateTime']), // Parse ISO string back to DateTime
    );
  }

  // Convert Event object to JSON string for easier storage if needed
  String toJson() => json.encode(toMap());

  // Create Event object from JSON string
  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}