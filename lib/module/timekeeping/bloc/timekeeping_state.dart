import '../model/timekeeping_model.dart';

class TimeKeepingState {
  final bool isLoading;
  final String? message;
  final List<TimeKeepingModel>? items;

  TimeKeepingState({
    this.isLoading = false,
    this.message,
    this.items,
  });
}

class TimeMyKeepingState {}

class TimeMyKeepingInitialState extends TimeMyKeepingState {}

class TimeMyKeepingLoadingState extends TimeMyKeepingState {}

class TimeMyKeepingSuccessState extends TimeMyKeepingState {
  final List<TimeMyKeepingModel> timeMyKeepingList;

  TimeMyKeepingSuccessState({required this.timeMyKeepingList});
}

class TimeMyKeepingFailedState extends TimeMyKeepingState {}

class TimeMyKeepingErrorState extends TimeMyKeepingState {
  final String errorMessage;

  TimeMyKeepingErrorState({required this.errorMessage});
}
