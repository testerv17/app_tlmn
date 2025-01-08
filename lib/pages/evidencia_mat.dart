import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:test_menu/main.dart';

class EvidenceScreen extends StatefulWidget {
  const EvidenceScreen({Key? key}) : super(key: key);

  @override
  State<EvidenceScreen> createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> {
  Uint8List? _image; // Store image as bytes for web or native
  final _workDoneRef = FirebaseDatabase.instance.ref('WorkDone');
  final _evidenceRef = FirebaseDatabase.instance.ref('Evidence');
  String? _selectedFolio;
  List<String> _folios = [];
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadFolios();
  }

  Future<void> _loadFolios() async {
    try {
      final snapshot = await _workDoneRef.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _folios = data.values.map((e) => e['folio'].toString()).toList();
        });
      }
    } catch (e) {
      print("Error loading folios: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading folios: $e")),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _image = bytes;
      });
    } else {
      print("No image selected.");
    }
  }

  Future<void> _uploadEvidence() async {
    if (_selectedFolio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a folio.")),
      );
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
      return;
    }

    try {
      print("Uploading image for folio: $_selectedFolio");
      print("Image size: ${_image!.lengthInBytes} bytes");

      // Get FirebaseStorage instance for the secondary app
      final storage = FirebaseStorage.instanceFor(app: secondaryApp);

      final fileName =
          'evidence_${_selectedFolio}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = storage.ref('TecnoLuminus/$fileName');

      final uploadTask = storageRef.putData(
        _image!,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      uploadTask.snapshotEvents.listen((event) {
        final progress = (event.bytesTransferred / event.totalBytes) * 100;
        setState(() {
          _uploadProgress = progress;
        });
        print("Upload progress: ${progress.toStringAsFixed(2)}%");
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully: $downloadUrl");

      // Save evidence details to Firebase Database (optional)
      final evidenceData = {
        'folio': _selectedFolio,
        'image_url': downloadUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await FirebaseDatabase.instanceFor(app: secondaryApp)
          .ref('WorkDone')
          .push()
          .set(evidenceData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Evidence uploaded successfully!")),
      );

      // Reset state after success
      setState(() {
        _image = null;
        _uploadProgress = 0.0;
      });
    } catch (e) {
      print("Error uploading evidence: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Add image before title
            Image.asset(
              'lib/images/tt.png', // Path to the image
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              'Evidencias Campo',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        shadowColor: Colors.amberAccent,
        backgroundColor: const Color.fromARGB(255, 28, 28, 37),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedFolio,
              onChanged: (value) {
                setState(() {
                  _selectedFolio = value;
                });
              },
              items: _folios.map((folio) {
                return DropdownMenuItem(
                    value: folio, child: Text("Folio: $folio"));
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Elige Folio",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Tomar Foto"),
            ),
            if (_image != null) ...[
              const SizedBox(height: 16),
              Text("IMagen Seleccionada:"),
              const SizedBox(height: 8),
              Image.memory(
                _image!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _uploadProgress / 100,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadEvidence,
              child: const Text("Subir Evidencia"),
            ),
          ],
        ),
      ),
    );
  }
}
