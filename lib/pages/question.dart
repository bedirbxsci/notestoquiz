import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class Test{
  List<String> question;
  List<List<String>> answers;
  String subject;

  Test(
      {required this.question,
      required this.answers,
      required this.subject});
}
