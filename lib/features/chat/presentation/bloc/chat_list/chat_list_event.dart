import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class ChatListLoadRequested extends ChatListEvent {
  final String userId;

  const ChatListLoadRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ChatListRefreshRequested extends ChatListEvent {
  const ChatListRefreshRequested();
}
