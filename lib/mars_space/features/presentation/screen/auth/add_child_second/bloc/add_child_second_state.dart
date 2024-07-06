part of 'add_child_second_bloc.dart';

@immutable
class AddChildSecondState {
  final LoadingState status;
  final String errorMessage;
  final Either<Failure, GetProfileResponseEntity> getResult;
  final Either<Failure, List<SearchStudentResponseEntity>> searchResult;

  const AddChildSecondState({
    this.status = LoadingState.EMPTY,
    this.errorMessage = "",
    this.getResult = const Left(Failure(errorMessage: 'NO GET')),
    this.searchResult = const Left(Failure(errorMessage: 'NO SEARCH')),
  });

  AddChildSecondState copyWith({
    LoadingState? status,
    String? errorMessage,
    Either<Failure, GetProfileResponseEntity>? getResult,
    Either<Failure, List<SearchStudentResponseEntity>>? searchResult,
  }) {
    return AddChildSecondState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      getResult: getResult ?? this.getResult,
      searchResult: searchResult ?? this.searchResult,
    );
  }
}
