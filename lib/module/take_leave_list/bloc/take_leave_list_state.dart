import '../model/take_list_model.dart';

class TakeLeaveListState {
  final List<TakeListModel>? takeList;
  final bool isLoading;

  TakeLeaveListState({this.takeList, this.isLoading = false});
}
