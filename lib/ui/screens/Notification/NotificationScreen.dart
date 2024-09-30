import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/Auth/authCubit.dart';
import 'package:news/cubits/UserNotification/userNotificationCubit.dart';
import 'package:news/ui/screens/Notification/Widgets/userNotificationWidget.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:news/utils/uiUtils.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => const NotificationScreen());
  }
}

class NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    getNotification();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void getNotification() {
    Future.delayed(Duration.zero, () {
      if (context.read<AuthCubit>().getUserId() != "0") context.read<UserNotificationCubit>().getUserNotification();
    });
  }

  setAppBar() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 52),
        child: Container(
          padding: EdgeInsetsDirectional.only(top: MediaQuery.of(context).padding.top + 10.0, start: 25),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomTextLabel(
              text: 'notificationLbl',
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: UiUtils.getColorScheme(context).primaryContainer, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
          ]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
            appBar: setAppBar(),
            body: (context.read<AuthCubit>().getUserId() != "0") ? const UserNotificationWidget() : Center(child: CustomTextLabel(text: 'notificationLogin', textAlign: TextAlign.center)));
      },
    );
  }
}
