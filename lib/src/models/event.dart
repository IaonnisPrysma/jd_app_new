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

  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dateTime': dateTime.toIso8601String(), 
    };
  }

  
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      dateTime: DateTime.parse(map['dateTime']), 
    );
  }

  
  String toJson() => json.encode(toMap());

  
  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}