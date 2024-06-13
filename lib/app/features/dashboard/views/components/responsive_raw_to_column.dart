import 'package:flutter/material.dart';

class ResponsiveRowColumn extends StatelessWidget {
  final Widget child1;
  final Widget child2;
  final Widget? child3;
  final Widget? child4;
  const ResponsiveRowColumn(this.child3, this.child4,
      {required this.child1, required this.child2, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 400) {
          // Mobile screen: use Column
          return Column(
            children: [child1, child2, child3!, child4!],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              child1,
              child2,
              child3!,
            ],
          );
        }
      },
    );
  }
}
