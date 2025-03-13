import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logging/logging.dart'; 

class GalleryView extends StatefulWidget {
  const GalleryView({super.key});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  
  List<File> _selectedMedia = []; 
  final Logger _logger = Logger('GalleryView'); 

  

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultipleMedia();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _selectedMedia = pickedFiles.map((xFile) => File(xFile.path)).toList();
      });

      for (var mediaFile in _selectedMedia) {
        _saveMediaLocally(mediaFile);
      }
    }
  }

  Future<void> _saveMediaLocally(File mediaFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final subDirectory = Directory('${directory.path}/gallery_media');

      if (!subDirectory.existsSync()) {
        subDirectory.createSync(recursive: true);
      }

      String fileName = mediaFile.path.split('/').last;
      final localFilePath = '${subDirectory.path}/$fileName';
      final localFile = File(localFilePath);

      await mediaFile.copy(localFilePath);

      _logger.info('Media saved locally to: ${localFile.path}'); 

      if (!mounted) return; 

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Media saved locally!')),
      );

    } catch (e) {
      _logger.severe('Error saving media locally:', e); 

      if (!mounted) return; 

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save media locally. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery Module (Local Storage)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickMedia,
              child: const Text('Pick Images/Videos'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _selectedMedia.isEmpty
                  ? const Text('No media selected yet.')
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: _selectedMedia.length,
                      itemBuilder: (context, index) {
                        final mediaFile = _selectedMedia[index];
                        final isImage = mediaFile.path.toLowerCase().endsWith('.jpg') ||
                            mediaFile.path.toLowerCase().endsWith('.jpeg') ||
                            mediaFile.path.toLowerCase().endsWith('.png') ||
                            mediaFile.path.toLowerCase().endsWith('.gif');

                        return isImage
                            ? Image.file(mediaFile, fit: BoxFit.cover)
                            : const Icon(Icons.video_collection, size: 50);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}