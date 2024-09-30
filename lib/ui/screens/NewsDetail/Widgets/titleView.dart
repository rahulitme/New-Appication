import 'package:flutter/material.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:news/utils/uiUtils.dart';

Widget titleView({required String title, required BuildContext context}) {
  return Padding(
      padding: const EdgeInsetsDirectional.only(top: 6.0),
      child: CustomTextLabel(text: title, textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.w600)));
}
