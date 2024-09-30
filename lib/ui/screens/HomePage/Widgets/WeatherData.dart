import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/utils/uiUtils.dart';
import 'package:news/data/models/WeatherData.dart';
import 'package:news/ui/widgets/customTextLabel.dart';

class WeatherDataView extends StatefulWidget {
  final WeatherData weatherData;
  final bool weatherLoad;

  const WeatherDataView({super.key, required this.weatherData, required this.weatherLoad});

  @override
  WeatherDataState createState() => WeatherDataState();
}

class WeatherDataState extends State<WeatherDataView> {
  @override
  void initState() {
    super.initState();
  }

  Widget weatherDataView() {
    DateTime now = DateTime.now();
    String day = DateFormat('EEEE').format(now);
    if (!widget.weatherLoad) {
      WeatherData weatherData = widget.weatherData;
      return Container(
          margin: const EdgeInsetsDirectional.only(top: 15.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: UiUtils.getColorScheme(context).surface),
          height: MediaQuery.of(context).size.height * 0.16,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    CustomTextLabel(
                        text: 'weatherLbl',
                        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer.withOpacity(0.8)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true),
                    Row(
                      children: <Widget>[
                        Image.network("https:${weatherData.icon!}", width: 40.0, height: 40.0),
                        Padding(
                            padding: const EdgeInsetsDirectional.only(start: 7.0),
                            child: CustomTextLabel(
                                text: "${weatherData.tempC!.toString()}\u2103",
                                textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer.withOpacity(0.8)),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1))
                      ],
                    )
                  ],
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    CustomTextLabel(
                        text: "${weatherData.name!},${weatherData.region!}",
                        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1),
                    CustomTextLabel(
                        text: weatherData.country!,
                        textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1),
                    Padding(
                        padding: const EdgeInsetsDirectional.only(top: 3.0),
                        child: CustomTextLabel(
                            text: day,
                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer.withOpacity(0.8)),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 1)),
                    Padding(
                        padding: const EdgeInsetsDirectional.only(top: 3.0),
                        child: CustomTextLabel(
                            text: weatherData.text!,
                            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer.withOpacity(0.8)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true)),
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsetsDirectional.only(top: 3.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(Icons.arrow_upward_outlined, size: 13.0, color: UiUtils.getColorScheme(context).primaryContainer),
                              CustomTextLabel(
                                  text: "H:${weatherData.maxTempC!.toString()}\u2103",
                                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer.withOpacity(0.8)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true),
                              Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 8.0),
                                  child: Icon(Icons.arrow_downward_outlined, size: 13.0, color: UiUtils.getColorScheme(context).primaryContainer)),
                              CustomTextLabel(
                                  text: "L:${weatherData.minTempC!.toString()}\u2103",
                                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer.withOpacity(0.8)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true)
                            ],
                          )),
                    )
                  ],
                ),
              )
            ],
          ));
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return weatherDataView();
  }
}
