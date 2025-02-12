// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:describe_ai/Feature/Home/Bloc/bloc/home_bloc.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  final HomeBloc homeBloc = HomeBloc();
  File? selectedImage; // Store the selected image at the class level

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade200,
        title: Center(
          child: Text('D E S C R I B E   A I'),
        ),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is ImagePicked) {
            setState(() {
              selectedImage = state.image; // Update UI with the picked image
            });
            homeBloc.add(AnalyzeImageEvent(state.image));
          }
        },
        builder: (context, state) {
          String? description;
          bool isLoading = false;

          if (state is ImageLoading) {
            isLoading = true;
          } else if (state is ImageAnalyzed) {
            description = state.description;
          } else if (state is ImageError) {
            description = state.message;
          }

          return Column(
            children: [
              // Image Display
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                ),
                child: selectedImage != null
                    ? Image.file(selectedImage!,
                        fit: BoxFit.cover, width: double.infinity)
                    : const Center(child: Text('Choose Image...')),
              ),

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        homeBloc.add(PickImageEvent(ImageSource.camera)),
                    child: const Text('Take Photo'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        homeBloc.add(PickImageEvent(ImageSource.gallery)),
                    child: const Text('Pick From Gallery'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Description or Loader
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 12), // Add margin
                  padding: EdgeInsets.all(12), // Padding for text inside
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6), // Rounded corners
                    border: Border.all(color: Colors.grey.shade600), // Border
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator()) // Show Loader
                      : SingleChildScrollView(
                          child: Text(
                            description ?? 'Choose an image to Describe.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
