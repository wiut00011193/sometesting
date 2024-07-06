part of 'splash_bloc.dart';

@immutable
class SplashState {
  final AuthState state;

  const SplashState({this.state = AuthState.SIGNIN});

  SplashState copyWith({AuthState? state}) {
    return SplashState(state: state ?? this.state);
  }
}
