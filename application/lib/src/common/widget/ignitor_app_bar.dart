import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ignitor/src/common/widget/base/common_actions.dart';

/// {@template ignitor_app_bar}
/// {@category Widget}
/// [AppBar] provides by Ignitor.
///
/// [actions] - list of actions, [DeveloperButton] will be added on every IgnitorAppBar widget.
///
/// thats allows to open developer tools everywhere in the app.
/// {@endtemplate}
class IgnitorAppBar extends StatelessWidget implements PreferredSizeWidget {
  factory IgnitorAppBar.none({
    final Widget? title,
    final List<Widget>? actions,
    final PreferredSizeWidget? bottomTabBar,
    final bool center = true,
    final Widget? leadingWidget,
    final bool? canPop,
    final PopInvokedWithResultCallback<Object>? didPopInvokedWithResult,
  }) => IgnitorAppBar._(
    title: title,
    actions: actions,
    bottomTabBar: bottomTabBar,
    center: center,
    leadingWidget: leadingWidget,
    canPop: canPop,
    didPopInvokedWithResult: didPopInvokedWithResult,
  );

  const IgnitorAppBar._({
    this.title,
    this.actions,
    this.center = true,
    this.bottomTabBar,
    this.leadingWidget,
    this.canPop,
    this.didPopInvokedWithResult,
  });
  final bool? canPop;
  final PopInvokedWithResultCallback<Object>? didPopInvokedWithResult;

  /// Если [leadingWidget] не null и перейти назад нельзя, то будет отображаться [leadingWidget]
  final Widget? leadingWidget;
  final bool center;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottomTabBar;
  final Widget? title;
  @override
  Widget build(BuildContext context) => AppBar(
    title: title,
    automaticallyImplyLeading: false,
    centerTitle: center,
    actions: CommonActions(context, actions),
    bottom: bottomTabBar,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    leadingWidth: 120,
    leading:
        Navigator.of(context).canPop()
            ? GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                if (canPop == false) {
                  didPopInvokedWithResult?.call(false, null);
                  return;
                } else {
                  //  Dependencies.of(context).appStatefullNavigation.router.pop();
                  Navigator.of(context).pop();
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 10, top: 0),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      //color: hexToColor('#849097'),
                      size: 18,
                    ),
                    Text(
                      'back',
                      style: TextStyle(
                        //color: hexToColor('#849097'),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
            : leadingWidget,
  );

  @override
  Size get preferredSize => Size.fromHeight(bottomTabBar != null ? 120 : 48);
}
