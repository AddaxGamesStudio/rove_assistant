import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rove_app_common/style/rove_palette.dart';
import 'package:rove_app_common/model/campaign_model.dart';
import 'package:rove_app_common/widgets/common/rove_text.dart';

class RoveStyles {
  RoveStyles._privateConstructor();

/* Text styles */

  static TextStyle headerStyle({Color color = RovePalette.title}) {
    return GoogleFonts.grenze(
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: 36,
    );
  }

  static TextStyle titleStyle({Color color = RovePalette.title}) {
    return GoogleFonts.grenze(
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: 24,
    );
  }

  static TextStyle subtitleStyle({Color color = RovePalette.title}) {
    return GoogleFonts.grenze(
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );
  }

  static TextStyle dialogTitleStyle() {
    return GoogleFonts.grenze(
      color: Colors.black54,
      fontWeight: FontWeight.w600,
      fontSize: 24,
    );
  }

  /* Spacing */

  static const verticalSpacingBox = SizedBox(height: 12);
  static const bevelRadius = Radius.circular(8);
  static const bodyHorizontalEdgeInsets = EdgeInsets.only(left: 12, right: 12);

  /* Common widgets */

  static Widget itemImage(String itemName,
      {double height = 340, bool unequipped = false}) {
    final asset = CampaignModel.instance.assetForItem(itemName: itemName);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(asset,
          height: height,
          fit: BoxFit.contain,
          color: unequipped ? Colors.grey : null,
          colorBlendMode: BlendMode.saturation),
    );
  }

  static Widget outlinedButton(
      {required String text, required Function() onPressed}) {
    return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Colors.black54, width: 1),
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
            )),
        child: Text(text));
  }

  static Widget dialogCancelButton({required Function() onPressed}) {
    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
        ),
        onPressed: onPressed,
        child: const Text('Cancel'));
  }

  static ButtonStyle _actionButtonStyle({required Color color}) {
    return ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ));
  }

  static Widget compactDialogActionButton(
      {required String title,
      required Color color,
      required Function() onPressed}) {
    return ElevatedButton(
      style: _actionButtonStyle(color: color),
      onPressed: onPressed,
      child: RoveText(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  static Widget backgroundBox(
      {String asset = 'assets/images/background.jpeg',
      Color? color,
      required Widget child}) {
    ColorFilter? colorFilter;
    if (color != null) {
      colorFilter = ColorFilter.mode(color, BlendMode.dst);
    }
    return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(asset),
              colorFilter: colorFilter,
              fit: BoxFit.cover),
        ),
        child: child);
  }

  static PreferredSizeWidget appBar(
      {String titleText = '',
      Widget? title,
      Widget? leading,
      Color backgroundColor = Colors.transparent,
      List<Widget> actions = const []}) {
    return AppBar(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        title: title ?? Text(titleText, style: RoveStyles.titleStyle()),
        leading: leading,
        leadingWidth: 72,
        actions: actions);
  }

  static Widget _appBarButton(
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

  static Widget leadingAppBarButton(
      {required String text,
      required Function() onPressed,
      Color color = RovePalette.title}) {
    return _appBarButton(
        text: text,
        onPressed: onPressed,
        margin: const EdgeInsets.only(left: 8),
        borderRadius: const BorderRadius.only(
            topLeft: bevelRadius, bottomLeft: bevelRadius),
        color: color);
  }

  static Widget trailingAppBarButton(
      {required String text, required Function() onPressed}) {
    return _appBarButton(
        text: text,
        onPressed: onPressed,
        margin: const EdgeInsets.only(right: 8),
        borderRadius: const BorderRadius.only(
            topRight: bevelRadius, bottomRight: bevelRadius));
  }
}
