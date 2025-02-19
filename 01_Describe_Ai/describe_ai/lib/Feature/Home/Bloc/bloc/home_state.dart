part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class ImageInitial extends HomeState {}

class ImageLoading extends HomeState {}

class ImagePicked extends HomeState {
  final File image;
  ImagePicked(this.image);
}

class ImageAnalyzed extends HomeState {
  final String description;
  ImageAnalyzed(this.description);
}

class ImageError extends HomeState {
  final String message;
  ImageError(this.message);
}
//
