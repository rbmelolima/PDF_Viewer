import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdf_viewer/shared/utils/assets_handler.dart';

Widget emptyDataWidget(String helperTxt, BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: SvgPicture.asset(
            AssetsPathHandler.emptyData,
            height: 200,
          ),
        ),
        Text(
          helperTxt,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
