import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_app_clean_architecture/core/error/failure.dart';
import 'package:posts_app_clean_architecture/core/strings/posts_message.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/entities/post.dart';
import 'package:posts_app_clean_architecture/features/posts/domain/use_cases/get_all_posts.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUseCase getAllPosts;
  PostsBloc({required this.getAllPosts}) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final posts = await getAllPosts();
        emit(_mapEithertoState(posts));
      } else if (event is RefreshPostsEvent) {
        emit(LoadingPostsState());
        final posts = await getAllPosts();
        emit(_mapEithertoState(posts));
      }
    });
  }
  PostsState _mapEithertoState(Either<Failure, List<Post>> posts) {
    return posts.fold(
        (failure) => ErrorPostsState(message: _FailureToMessage(failure)),
        (posts) => LoadedPostsState(posts: posts));
  }

  String _FailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case InternetFailure:
        return INTERNET_FAILURE_MESSAGE;
      case CachedPostsFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Failure, Plz Try Again !!';
    }
  }
}
