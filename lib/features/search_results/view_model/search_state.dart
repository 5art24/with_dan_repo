
import 'package:project1_collage/core/models/constant_event.dart';

// 🔹 States
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ConstantEventModel> results;
  final String query;

  SearchLoaded({required this.results, required this.query});
}

class SearchEmpty extends SearchState {
  final String? query;

  SearchEmpty({this.query});
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
