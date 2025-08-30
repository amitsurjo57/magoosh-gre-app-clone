import 'package:flutter/material.dart';
import 'package:magoosh_gre_app_clone/ui/widgets/common_appbar.dart';
import 'package:magoosh_gre_app_clone/ui/widgets/common_drawer.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flip_card/flip_card.dart';

class CardScreen extends StatefulWidget {
  final List<dynamic> listOfQuestion;

  const CardScreen({super.key, required this.listOfQuestion});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final FlipCardController _flipCardController = FlipCardController();

  int _index = 0;

  @override
  void dispose() {
    _flipCardController.controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(),
      endDrawer: commonDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: FlipCard(
          controller: _flipCardController,
          front: _front(),
          back: _back(),
          direction: FlipDirection.HORIZONTAL,
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
              widget.listOfQuestion[_index]['question'],
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
              widget.listOfQuestion[_index]['question'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 300,
              child: Text(widget.listOfQuestion[_index]['answer']),
            ),
            MaterialButton(
              onPressed: () {
                _flipCardController.toggleCardWithoutAnimation();
                _index++;
                setState(() {});
              },
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
              onPressed: () {
                _flipCardController.toggleCardWithoutAnimation();
                _index++;
                setState(() {});
              },
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
