import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/getSurveyAnswerCubit.dart';
import 'package:news/cubits/setSurveyAnswerCubit.dart';
import 'package:news/cubits/surveyQuestionCubit.dart';
import 'package:news/ui/styles/colors.dart';
import 'package:news/ui/widgets/circularProgressIndicator.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:news/utils/uiUtils.dart';
import 'package:news/cubits/appLocalizationCubit.dart';
import 'package:news/data/models/NewsModel.dart';
import 'package:news/ui/widgets/SnackBarWidget.dart';

class ShowSurveyQue extends StatefulWidget {
  final NewsModel model;
  final int index;
  final String surveyId;
  final bool isPaddingRequired;
  final Function(NewsModel, int) updateList;

  const ShowSurveyQue({super.key, required this.model, required this.index, required this.surveyId, required this.updateList, this.isPaddingRequired = true});

  @override
  ShowSurveyQueState createState() => ShowSurveyQueState();
}

class ShowSurveyQueState extends State<ShowSurveyQue> {
  String? optSel;

  @override
  Widget build(BuildContext context) {
    return showSurveyQue();
  }

  Widget showSurveyQue() {
    return BlocConsumer<SetSurveyAnsCubit, SetSurveyAnsState>(
        bloc: context.read<SetSurveyAnsCubit>(),
        listener: (context, state) {
          if (state is SetSurveyAnsInitial || state is SetSurveyAnsFetchInProgress) {
            Center(child: showCircularProgress(true, Theme.of(context).primaryColor));
          }
          if (state is SetSurveyAnsFetchSuccess) {
            debugPrint("Set survey ans success****${widget.model.id} ***** ${widget.model.question!} **** ${widget.surveyId}");
            context.read<SurveyQuestionCubit>().removeQuestion(widget.surveyId);
            context.read<GetSurveyAnsCubit>().getSurveyAns(langId: context.read<AppLocalizationCubit>().state.id);
          }
        },
        builder: (context, state) {
          return BlocConsumer<GetSurveyAnsCubit, GetSurveyAnsState>(
              bloc: context.read<GetSurveyAnsCubit>(),
              listener: (context, state) {
                if (state is GetSurveyAnsInitial || state is GetSurveyAnsFetchInProgress) {
                  Center(child: showCircularProgress(true, Theme.of(context).primaryColor));
                }
                if (state is GetSurveyAnsFetchSuccess) {
                  for (var element in state.getSurveyAns) {
                    if (element.id == widget.model.id) {
                      NewsModel newModel = element;
                      newModel.from = 2;
                      widget.updateList(newModel, widget.index);
                    }
                  }
                }
              },
              builder: (context, state) {
                return Padding(
                    padding: EdgeInsets.only(top: 15.0, left: (widget.isPaddingRequired) ? 15 : 0, right: (widget.isPaddingRequired) ? 15 : 0),
                    child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: UiUtils.getColorScheme(context).surface),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            CustomTextLabel(
                                text: widget.model.question!, textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, height: 1.0)),
                            Padding(
                                padding: const EdgeInsetsDirectional.only(top: 15.0, start: 7.0, end: 7.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: widget.model.optionDataList!.length,
                                    itemBuilder: (context, j) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: InkWell(
                                          child: Container(
                                              height: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  color: optSel == widget.model.optionDataList![j].id ? Theme.of(context).primaryColor.withOpacity(0.1) : UiUtils.getColorScheme(context).secondary),
                                              child: CustomTextLabel(
                                                  text: widget.model.optionDataList![j].options!,
                                                  textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                      color: optSel == widget.model.optionDataList![j].id ? Theme.of(context).primaryColor : UiUtils.getColorScheme(context).primaryContainer,
                                                      height: 1.0),
                                                  textAlign: TextAlign.center)),
                                          onTap: () {
                                            setState(() {
                                              optSel = widget.model.optionDataList![j].id;
                                            });
                                          },
                                        ),
                                      );
                                    })),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: InkWell(
                                  child: Container(
                                    height: 40.0,
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(7.0)),
                                    child: CustomTextLabel(
                                      text: 'submitBtn',
                                      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600, letterSpacing: 0.6),
                                    ),
                                  ),
                                  onTap: () async {
                                    if (optSel != null) {
                                      //get survey id from survey question
                                      String currentIndex = context.read<SurveyQuestionCubit>().getSurveyQuestionIndex(questionTitle: widget.model.question!);
                                      context.read<SetSurveyAnsCubit>().setSurveyAns(optId: optSel!, queId: currentIndex);
                                      await Future.delayed(Duration(seconds: 2));
                                    } else {
                                      showSnackBar(UiUtils.getTranslatedLabel(context, 'optSel'), context);
                                    }
                                  }),
                            )
                          ],
                        )));
              });
        });
  }
}
