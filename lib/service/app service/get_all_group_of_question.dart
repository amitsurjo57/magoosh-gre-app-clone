import '../../main.dart';
import '../../models/question_model.dart';

Future<List<QuestionGroupModel>?> getAllGroupOfQuestion() async {
  try {
    final getAllQuestionGroup = await supabase.from('question_group').select();

    List<QuestionGroupModel>? listOfQuestionGroup = [];

    for (var qus in getAllQuestionGroup) {
      listOfQuestionGroup.add(
        QuestionGroupModel(
          groupId: qus['group_id'],
          totalQuestion: qus['questions'].length,
          listOfQuestionInGroups: qus['questions'],
        ),
      );
    }

    return listOfQuestionGroup;
  } catch (e) {
    logger.e(e.toString());
    return null;
  }
}
