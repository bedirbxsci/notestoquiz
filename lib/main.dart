import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'firebase_options.dart';
import 'pages/question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageToTextChatGPT(),
    );
  }
}

class ImageToTextChatGPT extends StatefulWidget {
  const ImageToTextChatGPT({Key? key}) : super(key: key);

  @override
  _ImageToTextChatGPTState createState() => _ImageToTextChatGPTState();
}

class _ImageToTextChatGPTState extends State<ImageToTextChatGPT> {
  File? _image;
  String _responseText = '';

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });

      if (_image != null) {
        final recognizedText = await recognizeText(_image!);
        print(recognizedText);
        try {
          sendRecognizedText(recognizedText, "AP Bio");
        } catch (e) {
          print('Error while sending recognized text: $e');
          // You can also display the error to the user by updating the UI accordingly.
        }
      } else {
        print('No image selected');
      }
    }
  }

  Future<String> recognizeText(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      final RecognizedText recognizedText =
          await textDetector.processImage(inputImage);
      textDetector.close();
      return recognizedText.text;
    } catch (e) {
      print('Error while recognizing text: $e');
      throw e;
    }
  }

  Future<void> sendRecognizedText(String recognizedText, String course) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.247:5001/process_image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': recognizedText, "course": course}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        List question = stringtoJSON(response.body);
        print(question.toString());
        setState(() {
          _responseText = response.body;
        });
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while processing image: $e');
    }
  }

  Future<void> getGrades(String recognizedText, String course) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.247:5001/generate_grade'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': recognizedText, "course": course}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        List question = stringtoJSON(response.body);
        print(question.toString());
        setState(() {
          _responseText = response.body;
        });
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while processing image: $e');
    }
  }

  List stringtoJSON(String reply) {
    RegExp jsonSeparatorPattern = RegExp(r'}\s*,\s*{');
    List<String> jsonStrings = reply.split(jsonSeparatorPattern);

    List<Map<String, dynamic>> jsonObjects = [];

    for (String jsonStr in jsonStrings) {
      // Add curly braces if needed
      if (!jsonStr.startsWith('{')) {
        jsonStr = '{$jsonStr';
      }
      if (!jsonStr.endsWith('}')) {
        jsonStr = '$jsonStr}';
      }

      Map<String, dynamic> jsonObject = jsonDecode(jsonStr);
      jsonObjects.add(jsonObject);
    }
    return jsonObjects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null ? Text('No image selected.') : Image.file(_image!),
            FloatingActionButton(
              onPressed: getImage,
              tooltip: 'Pick Image',
              child: Icon(Icons.add_a_photo),
            ),
            SizedBox(height: 16),
            Text(_responseText),
          ],
        ),
      ),
    ));
  }
}
