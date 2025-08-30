import 'package:flutter/material.dart';

class AsynchronousWidget extends StatefulWidget {
  final Future<void> Function() function;
  final Widget widget;

  const AsynchronousWidget({
    super.key,
    required this.function,
    required this.widget,
  });

  @override
  State<AsynchronousWidget> createState() => _AsynchronousWidgetState();
}

class _AsynchronousWidgetState extends State<AsynchronousWidget> {
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    _function();
  }

  Future<void> _function() async {
    _inProgress = true;
    setState(() {});
    await widget.function();
    _inProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await _function(),
      child: Visibility(
        visible: !_inProgress,
        replacement: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        child: widget.widget,
      ),
    );
  }
}
