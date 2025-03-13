import 'package:flutter/material.dart';
import 'src/views/gallery_view.dart';
import 'package:jd_app_new/src/views/calendar_view.dart';
import 'package:jd_app_new/src/views/event_creation_view.dart';
import 'package:jd_app_new/src/views/event_detail_view.dart'; 
import 'package:jd_app_new/src/services/local_storage_service.dart'; 
import 'package:jd_app_new/src/models/event.dart'; 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multimedia Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      routes: {
        '/gallery': (context) => const GalleryView(),
        '/calendar': (context) => const CalendarView(),
        '/create_event': (context) => const EventCreationView(),
        '/event_detail': (context) => EventDetailView( 
          event: ModalRoute.of(context)!.settings.arguments as Event,
        ),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _localStorageService = LocalStorageService(); 
  List<Event> _events = []; 

  @override
  void initState() {
    super.initState();
    _loadEvents(); 
  }

  Future<void> _loadEvents() async {
    List<Event> loadedEvents = await _localStorageService.loadEvents();
    setState(() {
      _events = loadedEvents;
    });
  }

    void _reloadEvents() {
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to Multimedia Event Manager!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/gallery');
              },
              child: const Text('Go to Gallery'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/calendar');
              },
              child: const Text('View Calendar'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/create_event',
                  arguments: _reloadEvents, // Pass the callback
                );
              },
              child: const Text('Create Event'),
            ),
             const SizedBox(height: 20),
             const Text('Created Events:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             Expanded( 
               child: _events.isEmpty
                   ? const Center(child: Text('No events created yet.'))
                   : ListView.builder(
                       itemCount: _events.length,
                       itemBuilder: (context, index) {
                         final event = _events[index];
                         return Card( 
                           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                           child: ListTile(
                             title: Text(event.name),
                             subtitle: Text('Date: ${event.dateTime.toLocal()}'.split(' ')[0]), 
                             onTap: () {
                               Navigator.pushNamed(
                                 context,
                                 '/event_detail',
                                 arguments: event, 
                               );
                             },
                           ),
                         );
                       },
                     ),
             ),
          ],
        ),
      ),
    );
  }
}