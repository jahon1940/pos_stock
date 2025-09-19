import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget(
      {super.key, required this.keyI, required this.value, this.color});

  final String keyI;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: context.width * .17,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  keyI,
                  style: TextStyle(fontSize: 13, color: color),
                ),
                const Text(':'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SizedBox(
              width: context.width * .15,
              child: Text(
                value,
                style: TextStyle(fontSize: 13, color: color),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }
}
