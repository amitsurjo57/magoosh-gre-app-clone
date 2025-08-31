class UserSolvedQuestionModel {
  final String groupId;
  final List<dynamic> solved;
  final List<dynamic> notSolved;

  UserSolvedQuestionModel({
    required this.groupId,
    required this.solved,
    required this.notSolved,
  });
}
