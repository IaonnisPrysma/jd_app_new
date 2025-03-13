import 'package:flutter/material.dart';
import 'package:logging/logging.dart'; 
import '../models/event.dart'; 
import '../services/local_storage_service.dart'; 

class EventCreationView extends StatefulWidget {
  const EventCreationView({super.key});

  @override
  State<EventCreationView> createState() => _EventCreationViewState();
}

class _EventCreationViewState extends State<EventCreationView> {
  final _formKey = GlobalKey<FormState>(); 
  final _localStorageService = LocalStorageService(); 
  final Logger _logger = Logger('EventCreationView');

  
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025), 
      lastDate: DateTime(2026),  
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  Future<void> _createEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _startTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and start time')),
        );
        return;
      }

      
      String eventName = _eventNameController.text;
      String eventDescription = _eventDescriptionController.text;
      DateTime eventDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );

      Event newEvent = Event(
        name: eventName,
        description: eventDescription,
        dateTime: eventDateTime,
      );

      try {
        await _localStorageService.saveEvent(newEvent); 
        _logger.info('Event saved locally: ${newEvent.name}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created and saved locally!')),
        );
        _clearForm(); 
         Navigator.pop(context); 
      } catch (e) {
        _logger.severe('Error saving event locally:', e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save event locally. Please try again.')),
        );
      }
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _eventNameController.clear();
    _eventDescriptionController.clear();
    _selectedDate = null;
    _startTime = null;
    _endTime = null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView( 
            children: <Widget>[
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(labelText: 'Event Name*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: const InputDecoration(labelText: 'Event Description*'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event description';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
                maxLength: 200,
                maxLines: 3,
              ),
              ListTile(
                title: Text(_selectedDate == null ? 'Select Date*' : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0]), 
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
                contentPadding: EdgeInsets.zero, 
              ),
              if (_selectedDate == null)
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 5.0, bottom: 10.0),
                  child: Text(
                    'Please select event date',
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                  ),
                ),

              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(_startTime == null ? 'Start Time*' : 'Start: ${_startTime!.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectTime(context, true),
                      contentPadding: EdgeInsets.zero, 
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(_endTime == null ? 'End Time' : 'End: ${_endTime!.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectTime(context, false),
                      contentPadding: EdgeInsets.zero, 
                    ),
                  ),
                ],
              ),
               if (_startTime == null)
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 5.0, bottom: 10.0),
                  child: Text(
                    'Please select event start time',
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                  ),
                ),
              ElevatedButton(
                onPressed: _createEvent,
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}