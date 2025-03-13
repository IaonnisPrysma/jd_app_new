import 'package:flutter/material.dart';
import '../models/event.dart'; 

class EventDetailView extends StatelessWidget {
  const EventDetailView({super.key, required this.event});

  final Event event; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.name)), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Description:', style: Theme.of(context).textTheme.titleMedium),
            Text(event.description),
            const SizedBox(height: 20),
            Text('Date and Time:', style: Theme.of(context).textTheme.titleMedium),
            Text('${event.dateTime.toLocal()}'), 
            
          ],
        ),
      ),
    );
  }
}