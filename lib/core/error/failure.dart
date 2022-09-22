import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class InternetFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CachedPostsFailure extends Failure {
  @override
  List<Object?> get props => [];
}
