import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/style/rove_theme.dart';

class RoveAppBar extends StatelessWidget {
  const RoveAppBar(
      {super.key,
      this.backgroundColor = Colors.transparent,
      this.foregroundColor = RovePalette.title,
      this.titleText,
      this.title,
      this.leading,
      this.actions = const []})
      : assert(titleText != null || title != null);

  final Color backgroundColor;
  final Color foregroundColor;
  final String? titleText;
  final Widget? title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0.0,
        title: title ??
            Text(titleText!,
                style: GoogleFonts.grenze(
                  color: RovePalette.title,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                )),
        leading: leading,
        automaticallyImplyLeading: false,
        leadingWidth: 72,
        actions: actions);
  }
}

Widget _appBarButton(
    {required String text,
    required Function() onPressed,
    required EdgeInsets margin,
    required BorderRadius borderRadius,
    Color color = RovePalette.title}) {
  return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Container(
          margin: margin,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.only(left: 0, right: 0),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: onPressed,
              child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(text,
                      style: GoogleFonts.grenze(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                      ))))));
}

class RoveTrailingAppBarButton extends StatelessWidget {
  const RoveTrailingAppBarButton(
      {super.key, required this.text, required this.onPressed});

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return _appBarButton(
        text: text,
        onPressed: onPressed,
        margin: const EdgeInsets.only(right: 8),
        borderRadius: const BorderRadius.only(
            topRight: RoveTheme.bevelRadius,
            bottomRight: RoveTheme.bevelRadius));
  }
}

class RoveLeadingAppBarButton extends StatelessWidget {
  const RoveLeadingAppBarButton(
      {super.key,
      required this.text,
      this.color = RovePalette.title,
      required this.onPressed});

  final String text;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return _appBarButton(
        text: text,
        onPressed: onPressed,
        margin: const EdgeInsets.only(left: 8),
        borderRadius: const BorderRadius.only(
            topLeft: RoveTheme.bevelRadius, bottomLeft: RoveTheme.bevelRadius),
        color: color);
  }
}
