import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;

  const CounterButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.grey),
          minimumSize: Size(15, 38)),
      onPressed: onPressed,
      child: Icon(icon, size: 15),
    );
  }
}