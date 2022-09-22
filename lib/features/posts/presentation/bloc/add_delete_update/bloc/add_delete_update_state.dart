part of 'add_delete_update_bloc.dart';

abstract class AddDeleteUpdateState extends Equatable {
  const AddDeleteUpdateState();

  @override
  List<Object> get props => [];
}

class AddDeleteUpdateInitial extends AddDeleteUpdateState {}

class LoadingAddDeleteUpdateState extends AddDeleteUpdateState {}

class SuccessAddDeleteUpdateState extends AddDeleteUpdateState {
  final String message;

  SuccessAddDeleteUpdateState({required this.message});

  @override
  List<Object> get props => [message];
}

class ErrorAddDeleteUpdateState extends AddDeleteUpdateState {
  final String message;

  ErrorAddDeleteUpdateState({required this.message});
  @override
  List<Object> get props => [message];
}
