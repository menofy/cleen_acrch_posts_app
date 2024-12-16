part of 'add_delete_update_post_bloc.dart';

sealed class AddDeleteUpdatePostState extends Equatable {
  const AddDeleteUpdatePostState();
  
  @override
  List<Object> get props => [];
}

final class AddDeleteUpdatePostInitial extends AddDeleteUpdatePostState {}

final class LoadingAddDeleteUpdatePostState extends AddDeleteUpdatePostState {}

final class ErrorAddedDeleteUpdatePostState extends AddDeleteUpdatePostState {
  final String message;

  const ErrorAddedDeleteUpdatePostState({required this.message});

  @override
  List<Object> get props => [message];
}

final class MessageAddedDeleteUpdatePostState extends AddDeleteUpdatePostState {
  final String message;

  const MessageAddedDeleteUpdatePostState({required this.message});

  @override
  List<Object> get props => [message];
}
