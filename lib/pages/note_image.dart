import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'question.dart';

class ImageToText extends StatefulWidget {
  const ImageToText({Key? key}) : super(key: key);

  @override
  State<ImageToText> createState() => _ImageToText();
}

class _ImageToText extends State<ImageToText> {
  File? _image;
  String _responseText = '';
  List<Map<String, dynamic>> _questions = [];
  String _notes = '';
  bool loadingText = false;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      
      setState(() {
        _image = File(image.path);
       loadingText = true;
      });

      if (_image != null) {
        final recognizedText = await recognizeText(_image!);
        _notes += '$recognizedText + New Page';
      } else {
        print('No image selected');
      }
    }
  }

  Future<String> recognizeText(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final textDetector = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textDetector.processImage(inputImage);
      textDetector.close();
          setState(() {
      loadingText = false;
    });
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
        body: jsonEncode({'text': recognizedText}),
      );

      if (response.statusCode == 200) {
        print(response.body);
        List<Map<String, dynamic>> questions = stringtoJSON(response.body);
        print(questions.toString());
        setState(() {
          _responseText = response.body;
          _questions = questions;
        });
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  QuestionsFlow(questions: _questions, currentQuestionIndex: 0),
            ),
          );
        }
        ;
      } else {
        print('Failed to process image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while processing image: $e');
    }
  }

  List<Map<String, dynamic>> stringtoJSON(String reply) {
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
            !loadingText
              ? ElevatedButton(
                  onPressed: () {
                    try {
                      sendRecognizedText(_notes, "AP Bio");
                    } catch (e) {
                      print('Error while sending recognized text: $e');
                      // You can also display the error to the user by updating the UI accordingly.
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Adjust the corner radius as desired
                    ),
                  ),
                  child: Text('Get Questions'),
                )
              : CircularProgressIndicator(),
          ],
        ),
      ),
    ));
  }
}





class QuestionsFlow extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final int currentQuestionIndex;

  const QuestionsFlow(
      {super.key, required this.questions, required this.currentQuestionIndex});

  @override
  _QuestionsFlowState createState() => _QuestionsFlowState();
}

class _QuestionsFlowState extends State<QuestionsFlow> {
  void _nextQuestion() {
    if (widget.currentQuestionIndex < widget.questions.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionsFlow(
            questions: widget.questions,
            currentQuestionIndex: widget.currentQuestionIndex + 1,
          ),
        ),
      );
    }
  }

  void _previousQuestion() {
    if (widget.currentQuestionIndex > 0) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Question ${widget.currentQuestionIndex + 1}')),
      body: QuestionAnswerPage(
        question:
            widget.questions[widget.currentQuestionIndex]['question'] ?? '',
        answer: widget.questions[widget.currentQuestionIndex]['answer'] ?? '',
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousQuestion,
                icon: Icon(Icons.arrow_back),
                tooltip: 'Previous Question',
                disabledColor: Colors.grey,
                color:
                    widget.currentQuestionIndex > 0 ? Colors.blue : Colors.grey,
              ),
              IconButton(
                onPressed: _nextQuestion,
                icon: Icon(Icons.arrow_forward),
                tooltip: 'Next Question',
                disabledColor: Colors.grey,
                color: widget.currentQuestionIndex < widget.questions.length - 1
                    ? Colors.blue
                    : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
