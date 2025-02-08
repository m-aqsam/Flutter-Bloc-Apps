// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:describe_ai/Claude_Service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  // Variables and Stuff
  File? _image;

  String? _description;

  bool _isLoading = false;

  final _picker = ImagePicker();

  // Pick Image Methoc
  Future<void> _pickImage(ImageSource source) async {
    // Pick Image from gallery or camera
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 80,
      );

      // Image has been choosed start analysis
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        await _analyzeImage();
      }
    } catch (e) {
      print(e);
    }
  }

  // Analyze Image Method

  Future<void> _analyzeImage() async {
    if (_image == null) return; // Choose no image to analyze

    // loading...

    setState(() {
      _isLoading = true;
    });

    // Start Analyze the image

    try {
      final description = await ClaudeService().analyzeImage(_image!);
      setState(() {
        _description = description;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.deepPurple[200],
        appBar: AppBar(
          // backgroundColor: Colors.deepPurple[300],
          title: const Text(
            'D E S C R I B E  A I',
          ),
        ),
        body: Column(
          children: [
            // Dispalay Image
            Container(
              height: 300,
              color: Colors.grey,
              child: _image != null
                  ? Image.file(_image!,
                      fit: BoxFit.cover, width: double.infinity)
                  : Center(
                      child: Text('Choose Image...'),
                    ),
            ),

            SizedBox(height: 20),

            // Buttons

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('Take Photo'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Pick From Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Description

            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_description != null)
              Text(_description!),
          ],
        ));
  }
}
