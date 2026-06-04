import 'package:flutter/material.dart';
import 'package:pomogrow/core/theme/palette.dart';

class MenuSquare extends StatelessWidget {
  final String bigTitle;
  final String title;
  final String desc;
  const MenuSquare({
    super.key,
    required this.bigTitle,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: AppPalette.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bigTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.textBlack,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.titleMediumColor
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  //overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Text(
                  desc,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
