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
    _listOfQuestion.shuffle();

    setState(() {});
  }

  void _onTapKnew() {
    _didAnythingChange = true;
    _listOfSolvedQuestion.add(_listOfQuestion[_index]['question']);
    _listOfQuestion.removeAt(_index);
    _index++;
    if (_index > _listOfQuestion.length) _index = 0;
    _flipCardController.toggleCardWithoutAnimation();
    setState(() {});
  }

  void _onTapDoNotKnew() {
    _listOfQuestion.shuffle();
    _index++;
    if (_index > _listOfQuestion.length) _index = 0;
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

        bool shouldPop = false;

        try {
          shouldPop = true;
          if (_didAnythingChange) {
            final userId = await sharedPreferenceService.getData();
            final groupId = widget.questionGroupModel.groupId;

            final solved = await supabase
                .from('solved')
                .select()
                .eq('user_id', userId ?? '')
                .single();

            logger.i(solved);

            List<dynamic> userSolvedQuestions = solved['solved_question'];

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
          shouldPop = false;
          _didAnythingChange = false;
          logger.e(e.toString());
        }

        if (context.mounted && shouldPop) {
          Navigator.pop(context, _didAnythingChange);
        }
      },
      child: Scaffold(
        appBar: commonAppbar(),
        endDrawer: commonDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Visibility(
            visible: !_inProgress,
            replacement: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            child: FlipCard(
              controller: _flipCardController,
              front: _front(),
              back: _back(),
              direction: FlipDirection.HORIZONTAL,
            ),
          ),
        ),
      ),
    );
  }

  Widget _front() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Color(0xFFF4F4F5),
        borderRadius: BorderRadius.circular(25),
      ),
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
          Expanded(
            child: GestureDetector(
              onTap: () => _flipCardController.toggleCard(),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Tap to see meaning"),
                    Icon(Icons.arrow_forward),
                  ],
                ),
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
