import '../../main.dart';
import '../../models/user_solved_question_model.dart';

Future<List<UserSolvedQuestionModel>> getUserSolvedQuestion() async {
  try{

    final userId = await sharedPreferenceService.getData();

    final getUserSolvedQuestions = await supabase
        .from('solved')
        .select()
        .eq('user_id', userId ?? "")
        .single();

    doShowLogger? logger.i(getUserSolvedQuestions['solved_question']) : null;

    List<UserSolvedQuestionModel> listOfSolvedQuestion = [];

    for (var qus in getUserSolvedQuestions['solved_question']) {
      listOfSolvedQuestion.add(
        UserSolvedQuestionModel(
          groupId: qus['group_id'],
          solved: qus['solved'],
        ),
      );
    }

    return listOfSolvedQuestion;
  }catch(e){
    doShowLogger? logger.e(e.toString()) : null;
    return [];
  }
}
