part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class ItemTappedEvent extends MainEvent {
  final int index;

  ItemTappedEvent({required this.index});
}

class CheckScreenEvent extends MainEvent {
  final int currentIndex;

  CheckScreenEvent({required this.currentIndex});
}
