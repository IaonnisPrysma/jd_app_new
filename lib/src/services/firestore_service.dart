import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart'; 

class FirestoreService {
  FirebaseFirestore db = FirebaseFirestore.instance; 
  final Logger _logger = Logger('FirestoreService'); 

  FirestoreService() { 
  }

  

  Future<void> addDataToCollection(String collectionName, Map<String, dynamic> data) async {
    try {
      await db.collection(collectionName).add(data);
      _logger.info('Data successfully added to collection: $collectionName'); 
    } catch (e) {
      _logger.severe('Error adding data to collection: $collectionName', e); 
      
      rethrow; 
    }
  }

  
  
  
  
  
  
}