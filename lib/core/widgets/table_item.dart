import 'package:flutter/cupertino.dart';

class TableItem extends StatelessWidget {
  const TableItem(
      {super.key,
      required this.text,
      this.align = TextAlign.center,
      this.style});

  final String text;
  final TextAlign align;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Text(
          text,
          textAlign: align,
          style: style,
          maxLines: 2,
        ),
      ),
    );
  }
}
