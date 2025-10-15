// ignore_for_file: directives_ordering, use_key_in_widget_constructors, prefer_single_quotes

import '../../model/chuck_http_call.dart';
import '../../ui/widget/chuck_base_call_details_widget.dart';
import 'package:flutter/material.dart';

class ChuckCallErrorWidget extends StatefulWidget {
  final ChuckHttpCall call;

  const ChuckCallErrorWidget(this.call);

  @override
  State<StatefulWidget> createState() {
    return _ChuckCallErrorWidgetState();
  }
}

class _ChuckCallErrorWidgetState
    extends ChuckBaseCallDetailsWidgetState<ChuckCallErrorWidget> {
  ChuckHttpCall get _call => widget.call;

  @override
  Widget build(BuildContext context) {
    if (_call.error != null) {
      final List<Widget> rows = [];
      final dynamic error = _call.error!.error;
      var errorText = "Error is empty";
      if (error != null) {
        errorText = error.toString();
      }
      rows.add(getListRow("Error:", errorText));

      return Container(
        padding: const EdgeInsets.all(6),
        child: ListView(children: rows),
      );
    } else {
      return const Center(child: Text("Nothing to display here"));
    }
  }
}
