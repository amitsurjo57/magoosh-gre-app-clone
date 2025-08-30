import 'package:flutter/material.dart';
import 'package:magoosh_gre_app_clone/ui/widgets/asynchronous_widget.dart';
import '../../widgets/common_appbar.dart';
import '../../widgets/common_drawer.dart';
import 'package:magoosh_gre_app_clone/models/question_model.dart';
import 'package:magoosh_gre_app_clone/ui/widgets/group_of_words_card.dart';
import 'package:magoosh_gre_app_clone/service/app%20service/get_all_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QuestionGroupModel>? _listOfQuestionGroupModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      endDrawer: commonDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AsynchronousWidget(
          function: () async {
            _listOfQuestionGroupModel = await getAllData();
            setState(() {});
          },
          widget: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemCount: _listOfQuestionGroupModel?.length ?? 0,
            itemBuilder: (context, index) => GroupOfWordsCard(
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
            ),
          ),
        ),
      ),
    );
  }
}
