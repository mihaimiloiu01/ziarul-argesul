import 'package:flutter/material.dart';

/// Custom created button widget used for the social buttons added in the drawer.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({Key? key, required this.color, required this.icon})
      : super(key: key);

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 28),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.03,
      width: 0.005,
      decoration:
      BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child:
          IconButton(onPressed: () {},
              icon:  Icon(icon),
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0)
          ),
    );
  }
}