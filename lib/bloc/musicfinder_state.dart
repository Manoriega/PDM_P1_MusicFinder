part of 'musicfinder_bloc.dart';

abstract class MusicfinderState extends Equatable {
  const MusicfinderState();

  @override
  List<Object> get props => [];
}

class MusicfinderInitial extends MusicfinderState {}

class RecordingState extends MusicfinderState {}

class RecordFailedState extends MusicfinderState {
  final String errorMsg;

  const RecordFailedState({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

class SearchingState extends MusicfinderState {}

class SearchFailedState extends MusicfinderState {
  final String errorMsg;

  const SearchFailedState({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

class SearchSucceedState extends MusicfinderState {
  final Song song;

  const SearchSucceedState({required this.song});

  @override
  List<Object> get props => [song];
}
