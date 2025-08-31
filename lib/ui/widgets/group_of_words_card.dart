import 'package:flutter/material.dart';
import '../../models/question_model.dart';
import '../../models/user_solved_question_model.dart';
import '../screens/app screens/card_screen.dart';

class GroupOfWordsCard extends StatefulWidget {
  final void Function() onTap;
  final UserSolvedQuestionModel? userSolvedQuestionModel;
  final QuestionGroupModel questionGroupModel;
  final int groupIndex;

  const GroupOfWordsCard({
    super.key,
    required this.questionGroupModel,
    required this.groupIndex,
    this.userSolvedQuestionModel,
    required this.onTap,
  });

  @override
  State<GroupOfWordsCard> createState() => _GroupOfWordsCardState();
}

class _GroupOfWordsCardState extends State<GroupOfWordsCard> {
  late final int _totalQuestion;
  late final int _masteredQuestionCount;

  @override
  void initState() {
    super.initState();
    _totalQuestion = widget.questionGroupModel.totalQuestion;
    _masteredQuestionCount = widget.userSolvedQuestionModel != null
        ? widget.userSolvedQuestionModel!.solved.length
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        spacing: 16,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    "Common Words ${widget.groupIndex}",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "$_masteredQuestionCount of $_totalQuestion words mastered",
                ),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _totalQuestion > 0
                      ? _masteredQuestionCount / _totalQuestion
                      : 0.0,
                  backgroundColor: Color(0xFFEEEEEF),
                  valueColor: AlwaysStoppedAnimation(Colors.green),
                  minHeight: 30,
                  borderRadius: BorderRadiusDirectional.circular(8),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                bool shouldRefresh = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardScreen(
                      userSolvedQuestionModel: widget.userSolvedQuestionModel,
                      questionGroupModel: widget.questionGroupModel,
                      ),
                  ),
                );
                if(shouldRefresh){
                  widget.onTap();
                }else{
                  return;
                }
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFF4F4F5),
                  border: Border(top: BorderSide(color: Color(0xFFE5E5E5))),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text("Practice this deck", style: TextStyle(fontSize: 16)),
                    Icon(Icons.arrow_forward, size: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
