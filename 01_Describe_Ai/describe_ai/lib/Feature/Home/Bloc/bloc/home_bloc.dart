import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:describe_ai/Data/Claude_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ImagePicker _picker = ImagePicker();
  HomeBloc() : super(ImageInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<AnalyzeImageEvent>(_onAnalyzeImage);
  }

  Future<void> _onPickImage(
      PickImageEvent event, Emitter<HomeState> emit) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: event.source,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        emit(ImagePicked(File(pickedFile.path)));
      }
    } catch (e) {
      emit(ImageError('Failed to pick image: $e'));
    }
  }

  Future<void> _onAnalyzeImage(
      AnalyzeImageEvent event, Emitter<HomeState> emit) async {
    emit(ImageLoading());
    try {
      final description = await ClaudeService().analyzeImage(event.image);
      emit(ImageAnalyzed(description));
    } catch (e) {
      emit(ImageError('Failed to analyze image: $e'));
    }
  }
}
