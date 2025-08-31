import 'package:flutter/material.dart';
import '../../../service/app%20service/user_solved_question.dart';
import '../../../models/user_solved_question_model.dart';
import '../../widgets/common_appbar.dart';
import '../../widgets/common_drawer.dart';
import '../../../models/question_model.dart';
import '../../widgets/group_of_words_card.dart';
import '../../../service/app%20service/get_all_group_of_question.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QuestionGroupModel>? _listOfQuestionGroupModel;
  List<UserSolvedQuestionModel>? _listOfUserSolvedQuestionModel;

  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    _inProgress = true;
    setState(() {});
    _listOfQuestionGroupModel = await getAllGroupOfQuestion();
    _listOfUserSolvedQuestionModel = await getUserSolvedQuestion();
    _inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      endDrawer: commonDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => await _getData(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: !_inProgress,
            replacement: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemCount: _listOfQuestionGroupModel?.length ?? 0,
              itemBuilder: (context, index) {
                UserSolvedQuestionModel? userSolvedQuestionModel;

                for (UserSolvedQuestionModel qusModel
                    in _listOfUserSolvedQuestionModel ?? []) {
                  if (_listOfQuestionGroupModel![index].groupId ==
                      qusModel.groupId) {
                    userSolvedQuestionModel = qusModel;
                  }
                }

                return GroupOfWordsCard(
                  onTap: () async => await _getData(),
                  userSolvedQuestionModel: userSolvedQuestionModel,
                  groupIndex: index + 1,
                  questionGroupModel: QuestionGroupModel(
                    groupId: _listOfQuestionGroupModel?[index].groupId ?? " ",
                    totalQuestion:
                        _listOfQuestionGroupModel?[index].totalQuestion ?? 0,
                    listOfQuestionInGroups:
                        _listOfQuestionGroupModel?[index]
                            .listOfQuestionInGroups ??
                        [],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
