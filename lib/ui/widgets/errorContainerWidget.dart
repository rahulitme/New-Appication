import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:news/ui/widgets/customTextBtn.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:news/utils/uiUtils.dart';

class ErrorContainerWidget extends StatelessWidget {
  final String errorMsg;
  final Function onRetry;
  const ErrorContainerWidget({super.key, required this.errorMsg, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            (errorMsg.contains(UiUtils.getTranslatedLabel(context, 'internetmsg')))
                ? Container(
                    width: MediaQuery.of(context).size.width * (0.7),
                    margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + MediaQuery.of(context).size.height * (0.05)),
                    height: MediaQuery.of(context).size.height * (0.4),
                    child: Lottie.asset("assets/animations/noInternet.json"))
                : SizedBox(height: MediaQuery.of(context).size.height * (0.2)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomTextLabel(
                    text: errorMsg,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textStyle: TextStyle(color: Theme.of(context).colorScheme.primaryContainer, fontSize: 16, fontWeight: FontWeight.w300))),
            SizedBox(height: MediaQuery.of(context).size.height * (0.035)),
            CustomTextButton(
                onTap: () {
                  onRetry.call();
                },
                buttonStyle: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(UiUtils.getColorScheme(context).primary), shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                textWidget: CustomTextLabel(
                  text: 'RetryLbl',
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: UiUtils.getColorScheme(context).surface, fontWeight: FontWeight.w600, fontSize: 21, letterSpacing: 0.6),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * (0.15)),
          ],
        ));
  }
}
