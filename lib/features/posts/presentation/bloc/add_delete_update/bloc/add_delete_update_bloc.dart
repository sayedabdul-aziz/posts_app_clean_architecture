import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/use_cases/add_post.dart';

import '../../../../../../core/error/failure.dart';
import '../../../../../../core/strings/posts_message.dart';
import '../../../../domain/entities/post.dart';
import '../../../../domain/use_cases/delete_post.dart';
import '../../../../domain/use_cases/update_post.dart';

part 'add_delete_update_event.dart';
part 'add_delete_update_state.dart';

class AddDeleteUpdateBloc
    extends Bloc<AddDeleteUpdateEvent, AddDeleteUpdateState> {
  final AddPostsUseCase addPostsUseCase;
  final UpdatePostsUseCase updatePostsUseCase;
  final DeletePostsUseCase deletePostsUseCase;
  AddDeleteUpdateBloc(
      {required this.addPostsUseCase,
      required this.deletePostsUseCase,
      required this.updatePostsUseCase})
      : super(AddDeleteUpdateInitial()) {
    on<AddDeleteUpdateEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdateState());
        var doneOrFailure = await addPostsUseCase(event.post);
        emit(_mapEitherToState(doneOrFailure, ADD_SUCCESS_MESSAGE));
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdateState());
        var doneOrFailure = await updatePostsUseCase(event.post);
        emit(_mapEitherToState(doneOrFailure, UPDATE_SUCCESS_MESSAGE));
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdateState());
        var doneOrFailure = await deletePostsUseCase(event.postId);
        emit(_mapEitherToState(doneOrFailure, DELETE_SUCCESS_MESSAGE));
      }
    });
  }
  AddDeleteUpdateState _mapEitherToState(
      Either<Failure, Unit> addOrUpdateOrDelete, String message) {
    return addOrUpdateOrDelete.fold(
        (failure) =>
            ErrorAddDeleteUpdateState(message: _FailureToMessage(failure)),
        (_) => SuccessAddDeleteUpdateState(message: message));
  }

  String _FailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case InternetFailure:
        return INTERNET_FAILURE_MESSAGE;
      default:
        return 'Unexpected Failure, Plz Try Again !!';
    }
  }
}
