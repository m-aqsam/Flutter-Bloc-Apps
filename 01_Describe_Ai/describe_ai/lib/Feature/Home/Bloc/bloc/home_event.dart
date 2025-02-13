part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class PickImageEvent extends HomeEvent {
  final ImageSource source;

  PickImageEvent(this.source);
}

class AnalyzeImageEvent extends HomeEvent {
  final File image;

  AnalyzeImageEvent(this.image);
}
//
