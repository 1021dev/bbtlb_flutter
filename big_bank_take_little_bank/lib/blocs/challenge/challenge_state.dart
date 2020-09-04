import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class ChallengeState extends Equatable {
  final bool isLoading;
  final bool isRequesting;
  final bool isGamePlay;
  final List<ChallengeModel> challengeList;
  final List<ChallengeModel> pendingRequestList;
  final List<ChallengeModel> receivedRequestList;
  final List<ChallengeModel> upcomingChallengeList;

  ChallengeState({
    this.isLoading = false,
    this.isRequesting = false,
    this.isGamePlay = false,
    this.challengeList = const [],
    this.pendingRequestList = const [],
    this.receivedRequestList = const [],
    this.upcomingChallengeList = const [],
  });

  @override
  List<Object> get props => [
    isLoading,
    isRequesting,
    isGamePlay,
    challengeList,
    pendingRequestList,
    receivedRequestList,
    upcomingChallengeList,
  ];
  ChallengeState copyWith({
    bool isLoading,
    bool isRequesting,
    bool isGamePlay,
    List<ChallengeModel> challengeList,
    List<ChallengeModel> pendingRequestList,
    List<ChallengeModel> receivedRequestList,
    List<ChallengeModel> upcomingChallengeList,
  }) {
    return ChallengeState(
      isLoading: isLoading ?? this.isLoading,
      isRequesting: isRequesting ?? this.isRequesting,
      isGamePlay: isGamePlay ?? this.isGamePlay,
      challengeList: challengeList ?? this.challengeList,
      pendingRequestList: pendingRequestList ?? this.pendingRequestList,
      receivedRequestList: receivedRequestList ?? this.receivedRequestList,
      upcomingChallengeList: upcomingChallengeList ?? this.upcomingChallengeList,
    );
  }
}
