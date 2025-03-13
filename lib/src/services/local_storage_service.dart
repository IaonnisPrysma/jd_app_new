import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart'; 

class LocalStorageService {
  static const String _eventsKey = 'events'; 

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  
  Future<void> saveEvent(Event event) async {
    final SharedPreferences prefs = await _prefs;
    List<String> eventsJsonList = prefs.getStringList(_eventsKey) ?? []; 

    eventsJsonList.add(event.toJson()); 
    await prefs.setStringList(_eventsKey, eventsJsonList); 
  }

  
  Future<List<Event>> loadEvents() async {
    final SharedPreferences prefs = await _prefs;
    List<String> eventsJsonList = prefs.getStringList(_eventsKey) ?? []; 

    return eventsJsonList.map((eventJson) => Event.fromJson(eventJson)).toList(); 
  }

  
  Future<void> clearEvents() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(_eventsKey);
  }
}