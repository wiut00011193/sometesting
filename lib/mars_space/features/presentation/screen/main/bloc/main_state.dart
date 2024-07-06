part of 'main_bloc.dart';

@immutable
class MainState {
  final int selectedIndex;
  final bool checkScreen;

  const MainState({this.selectedIndex = 0, this.checkScreen = false});

  MainState copyWith({
    int? selectedIndex,
    bool? checkScreen,
  }) {
    return MainState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      checkScreen: checkScreen ?? this.checkScreen,
    );
  }
}
