part of 'musicfinder_bloc.dart';

abstract class MusicfinderEvent extends Equatable {
  const MusicfinderEvent();

  @override
  List<Object> get props => [];
}

class RecordEvent extends MusicfinderEvent {}
