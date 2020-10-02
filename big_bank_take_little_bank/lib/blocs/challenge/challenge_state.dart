import 'package:big_bank_take_little_bank/models/challenge_model.dart';
import 'package:big_bank_take_little_bank/models/message_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChallengeState extends Equatable {
  final bool isLoading;
  final bool isRequesting;
  final bool isGamePlay;
  final List<ChallengeModel> challengeList;
  final List<ChallengeModel> pendingRequestList;
  final List<ChallengeModel> receivedRequestList;
  final List<ChallengeModel> upcomingChallengeList;
  final List<ChallengeModel> liveChallengeList;
  final List<ChallengeModel> liveChallengeResultList;
  final List<ChallengeModel> scheduleChallengeList;
  final List<ChallengeModel> scheduleChallengeRequestList;

  final ChallengeModel selectedChallenge;
  final List<MessageModel> publicMessages;
  final List<MessageModel> privateMessages;
  final bool isChatMode;
  final ChallengeModel standardChallenge;
  final ChallengeModel liveChallenge;
  final ChallengeModel scheduleChallenge;

  ChallengeState({
    this.isLoading = false,
    this.isRequesting = false,
    this.isGamePlay = false,
    this.challengeList = const [],
    this.pendingRequestList = const [],
    this.receivedRequestList = const [],
    this.upcomingChallengeList = const [],
    this.liveChallengeList = const [],
    this.liveChallengeResultList = const [],
    this.scheduleChallengeList = const [],
    this.scheduleChallengeRequestList = const [],
    this.selectedChallenge,
    this.publicMessages = const [],
    this.privateMessages = const [],
    this.isChatMode = false,
    this.standardChallenge,
    this.liveChallenge,
    this.scheduleChallenge,
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
    liveChallengeResultList,
    liveChallengeList,
    scheduleChallengeList,
    scheduleChallengeRequestList,
    selectedChallenge,
    publicMessages,
    privateMessages,
    isChatMode,
    standardChallenge,
    liveChallenge,
    scheduleChallenge,
  ];
  ChallengeState copyWith({
    bool isLoading,
    bool isRequesting,
    bool isGamePlay,
    List<ChallengeModel> challengeList,
    List<ChallengeModel> pendingRequestList,
    List<ChallengeModel> receivedRequestList,
    List<ChallengeModel> upcomingChallengeList,
    List<ChallengeModel> liveChallengeList,
    List<ChallengeModel> liveChallengeResultList,
    List<ChallengeModel> scheduleChallengeList,
    List<ChallengeModel> scheduleChallengeRequestList,
    ChallengeModel selectedChallenge,
    List<MessageModel> publicMessages,
    List<MessageModel> privateMessages,
    bool isChatMode,
    ChallengeModel standardChallenge,
    ChallengeModel liveChallenge,
    ChallengeModel scheduleChallenge,
  }) {
    return ChallengeState(
      isLoading: isLoading ?? this.isLoading,
      isRequesting: isRequesting ?? this.isRequesting,
      isGamePlay: isGamePlay ?? this.isGamePlay,
      challengeList: challengeList ?? this.challengeList,
      pendingRequestList: pendingRequestList ?? this.pendingRequestList,
      receivedRequestList: receivedRequestList ?? this.receivedRequestList,
      upcomingChallengeList: upcomingChallengeList ?? this.upcomingChallengeList,
      liveChallengeList: liveChallengeList ?? this.liveChallengeList,
      liveChallengeResultList: liveChallengeResultList ?? this.liveChallengeResultList,
      scheduleChallengeList: scheduleChallengeList ?? this.scheduleChallengeList,
      scheduleChallengeRequestList: scheduleChallengeRequestList ?? this.scheduleChallengeRequestList,
      selectedChallenge: selectedChallenge ?? this.selectedChallenge,
      publicMessages: publicMessages ?? this.publicMessages,
      privateMessages: privateMessages ?? this.privateMessages,
      isChatMode: isChatMode ?? this.isChatMode,
      standardChallenge: standardChallenge ?? this.standardChallenge,
      liveChallenge: liveChallenge ?? this.liveChallenge,
      scheduleChallenge: scheduleChallenge ?? this.scheduleChallenge,
    );
  }
}
