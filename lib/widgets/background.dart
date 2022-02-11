import 'package:flutter/material.dart';

class BackgroundImageContainer extends StatelessWidget {
  final Widget child;
  final String imageUrl;
  const BackgroundImageContainer(
      {required this.child, required this.imageUrl, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Place as the child widget of a scaffold
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
