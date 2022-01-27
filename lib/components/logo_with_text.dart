import 'package:flutter/material.dart';
import 'package:corefit_academy/utilities/constants.dart';

class LogoWithText extends StatelessWidget {
  const LogoWithText(
      {Key? key,
      required this.tag,
      required this.logoCircleWidth,
      required this.logoCircleHeight,
      required this.logoIconSize,
      required this.logoTextFontSize})
      : super(key: key);

  final double logoCircleWidth;
  final double logoCircleHeight;
  final double logoIconSize;
  final double logoTextFontSize;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: logoCircleWidth,
            height: logoCircleHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              size: logoIconSize,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            'CoreFit Academy',
            style: coreFitTextStyle.copyWith(
                fontSize: logoTextFontSize,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
