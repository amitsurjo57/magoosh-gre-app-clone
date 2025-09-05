import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magoosh_gre_app_clone/main.dart';
import '../../../models/question_model.dart';
import '../../widgets/common_appbar.dart';
import '../../widgets/common_drawer.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flip_card/flip_card.dart';

class CardScreen extends StatefulWidget {
  final QuestionGroupModel questionGroupModel;
  final List listOfUserSolvedQuestions;

  const CardScreen({
    super.key,
    required this.questionGroupModel,
    required this.listOfUserSolvedQuestions,
  });

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final FlipCardController _flipCardController = FlipCardController();

  final Random _random = Random();

  List<dynamic> _listOfQuestion = [];
  List<dynamic> _listOfSolvedQuestion = [];
  int _index = 0;
  bool _didAnythingChange = false;
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _getAndFormatData();
  }

  void _getAndFormatData() {
    _listOfSolvedQuestion.clear();
    _listOfQuestion.clear();

    _listOfQuestion = widget.questionGroupModel.listOfQuestionInGroups;
    _listOfSolvedQuestion = widget.listOfUserSolvedQuestions;

    if (_listOfSolvedQuestion.isNotEmpty) {
      _listOfQuestion.removeWhere(
        (qus) => _listOfSolvedQuestion.contains(qus['question']),
      );
    }

    logger.i("List of question in groups:\n$_listOfQuestion");

    logger.i("User Solved question:\n$_listOfSolvedQuestion");

    setState(() {});
  }

  void _onTapKnew() {
    if (_listOfQuestion.isEmpty) {
      setState(() {});
      return;
    }
    logger.d("Index: $_index\nLength: ${_listOfQuestion.length}");
    _didAnythingChange = true;
    _listOfSolvedQuestion.add(_listOfQuestion[_index]['question']);
    _listOfQuestion.removeAt(_index);
    _index = _listOfQuestion.isEmpty
        ? 0
        : _random.nextInt(_listOfQuestion.length);
    _flipCardController.toggleCardWithoutAnimation();
    setState(() {});
  }

  void _onTapDoNotKnew() {
    logger.d("Index: $_index\nLength: ${_listOfQuestion.length}");
    _index = _random.nextInt(_listOfQuestion.length);
    _flipCardController.toggleCardWithoutAnimation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          return;
        }

        _inProgress = true;
        setState(() {});

        try {
          if (_didAnythingChange) {
            final userId = await sharedPreferenceService.getData();
            final groupId = widget.questionGroupModel.groupId;

            final solved = await supabase
                .from('solved')
                .select()
                .eq('user_id', userId ?? '')
                .single();

            logger.i(solved);

            logger.d("List of Solved Question: $_listOfSolvedQuestion)");

            List<dynamic> userSolvedQuestions = solved['solved_question'];

            if (userSolvedQuestions.isEmpty) {
              userSolvedQuestions.add({
                "group_id": groupId,
                "solved": _listOfSolvedQuestion,
              });

              await supabase
                  .from('solved')
                  .update({'solved_question': userSolvedQuestions})
                  .eq('user_id', userId ?? "");

              _inProgress = true;
              setState(() {});

              if (context.mounted) {
                Navigator.pop(context, _didAnythingChange);
              }
              return;
            }

            bool isGroupExist = false;

            for (var qus in userSolvedQuestions) {
              if (qus['group_id'] == groupId) {
                isGroupExist = true;
                break;
              }
            }

            if (!isGroupExist) {
              userSolvedQuestions.add({
                "group_id": groupId,
                "solved": _listOfSolvedQuestion,
              });

              await supabase
                  .from('solved')
                  .update({'solved_question': userSolvedQuestions})
                  .eq('user_id', userId ?? "");

              _inProgress = true;
              setState(() {});

              if (context.mounted) {
                Navigator.pop(context, _didAnythingChange);
              }
              return;
            }

            for (var qus in userSolvedQuestions) {
              if (qus['group_id'] == groupId) {
                qus['solved'] = _listOfSolvedQuestion;
                break;
              }
            }

            await supabase
                .from('solved')
                .update({'solved_question': userSolvedQuestions})
                .eq('user_id', userId ?? "");

            _inProgress = true;
            setState(() {});
          }
        } catch (e) {
          _didAnythingChange = false;
          logger.e(e.toString());
        }

        if (context.mounted) {
          Navigator.pop(context, _didAnythingChange);
        }
      },
      child: Scaffold(
        appBar: commonAppbar(),
        endDrawer: commonDrawer(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Visibility(
            visible: !_inProgress,
            replacement: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            child: _listOfQuestion.isEmpty
                ? Container(
                    width: double.infinity,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE5E5E5)),
                      ),
                    ),
                    child: Text(
                      "You solved all questions",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : FlipCard(
                    controller: _flipCardController,
                    front: _front(),
                    back: _back(),
                    flipOnTouch: false,
                    direction: FlipDirection.HORIZONTAL,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _front() {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              border: Border(bottom: BorderSide(color: Color(0xFFE5E5E5))),
            ),
            child: Text(
              _listOfQuestion[_index]['question'],
              style: TextStyle(fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () => _flipCardController.toggleCard(),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F5),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Tap to see meaning"),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _back() {
    return Container(
      width: double.infinity,
      height: 300,
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFFF4F4F5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              _listOfQuestion[_index]['question'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 300,
              child: Text(_listOfQuestion[_index]['answer']),
            ),
            MaterialButton(
              onPressed: _onTapKnew,
              color: Color(0xFFBBF4CB),
              height: 60,
              minWidth: double.minPositive,
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.check, color: Colors.green),
                  Text(
                    "I knew this word",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: _onTapDoNotKnew,
              color: Color(0xFFF9CCCD),
              height: 60,
              minWidth: double.minPositive,
              child: Row(
                spacing: 8,
                children: [
                  Icon(Icons.close, color: Colors.red),
                  Text(
                    "I didn't know this word",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
