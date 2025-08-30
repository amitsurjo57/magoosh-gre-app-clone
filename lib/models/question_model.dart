class QuestionGroupModel {
  final String groupId;
  final int totalQuestion;
  final List<dynamic> listOfQuestionInGroups;

  QuestionGroupModel({
    required this.groupId,
    required this.totalQuestion,
    required this.listOfQuestionInGroups,
  });
}
