import 'package:flutter/material.dart';
import 'package:rove_assistant/widgets/common/image_shadow.dart';
import 'package:rove_assistant/widgets/common/rove_icon.dart';
import 'package:rove_assistant/widgets/common/rove_text.dart';
import 'package:rove_assistant/widgets/common/rover_class_icon.dart';
import 'package:rove_data_types/rove_data_types.dart';
import 'action_list_widget.dart';
import 'card_flip_footer.dart';
import 'card_shadow.dart';
import 'rove_action_layout.dart';
import 'triangle_widget.dart';

RoveAction? _flipAction(List<RoveAction> actions) {
  final action = actions.lastOrNull;
  if (action == null) {
    return null;
  }
  if (action.type != RoveActionType.flipCard) {
    return null;
  }
  return action;
}

class CardWidget extends StatelessWidget {
  final TwoSidedCardDef card;
  final String cardType;
  final Widget subtitle;
  final int? selectedGroupIndex;
  final int? selectedActionIndex;
  final Function(int)? onSelectedGroup;
  final TwoSidedCardDef backCard;
  final String backCardType;
  final RoverClass roverClass;

  static const Size size = Size(300, 410);

  const CardWidget({
    super.key,
    required this.subtitle,
    required this.card,
    required this.cardType,
    this.selectedGroupIndex,
    this.selectedActionIndex,
    this.onSelectedGroup,
    required this.backCard,
    required this.backCardType,
    required this.roverClass,
  });

  @override
  Widget build(BuildContext context) {
    final headerBackgroundColor = roverClass.color;
    final bodyBackgroundColor = roverClass.colorDark;
    final id = card.id;
    final actions = card.actions;
    final rowCount = actions.fold(0, (sum, action) => sum + action.rowCount);
    final compact = rowCount >= 4;
    final flipAction = _flipAction(actions);
    final bodyActions = actions.toList()..remove(flipAction);

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: bodyBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              _SkillHeader(
                  backgroundColor: headerBackgroundColor,
                  cardName: card.name,
                  upgrade: card.isUpgrade),
              _SkillSubheader(
                  backgroundColor: headerBackgroundColor,
                  type: cardType,
                  subtype: card.subtype.toLowerCase(),
                  child: subtitle),
              Expanded(
                child: _SkillBody(
                  actions: bodyActions,
                  selectedGroupIndex: selectedGroupIndex,
                  selectedIndex: selectedActionIndex,
                  onSelectedGroup: onSelectedGroup,
                  headerBackgroundColor: headerBackgroundColor,
                  bodyBackgroundColor: bodyBackgroundColor,
                  compact: compact,
                ),
              ),
              if (flipAction != null)
                CardFlipFooter(
                    borderColor: headerBackgroundColor, action: flipAction),
              _SkillFooter(
                  backgroundcolor: headerBackgroundColor,
                  backCard: backCard,
                  backCardType: backCardType,
                  roverClass: roverClass),
              Container(
                width: double.infinity,
                height: 35,
                decoration: BoxDecoration(
                  color: headerBackgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
              ),
            ],
          ),
          if (id != null)
            Positioned(
              bottom: 6 + 35 + 35,
              right: 10,
              child: CardShadow(
                child: RoveText(
                  id,
                  style: const TextStyle(color: Colors.white, fontSize: 7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SkillFooter extends StatelessWidget {
  const _SkillFooter({
    required this.backgroundcolor,
    required this.roverClass,
    required this.backCard,
    required this.backCardType,
  });

  final Color backgroundcolor;
  final RoverClass roverClass;
  final TwoSidedCardDef backCard;
  final String backCardType;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 35,
        color: backgroundcolor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: const Alignment(0.6, 0),
              width: 60,
              child: ImageShadow(
                opacity: 0.75,
                sigma: 0.5,
                offset: const Offset(0, 0),
                child: RoverClassIcon(roverClass),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
                padding: const EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  spacing: 8,
                  children: [
                    CardShadow(
                      child: RoveIcon(backCardType, height: 15),
                    ),
                    const VerticalDivider(
                        color: Colors.white,
                        width: 4,
                        thickness: 1,
                        indent: 4,
                        endIndent: 4),
                    Expanded(
                      child: Center(
                        child: CardShadow(
                          child: RoveText.subtitle(
                            backCard.name,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                        color: Colors.white,
                        width: 4,
                        thickness: 1,
                        indent: 4,
                        endIndent: 4),
                    CardShadow(
                      child:
                          RoveIcon(backCard.subtype.toLowerCase(), height: 15),
                    ),
                    const CardShadow(
                        child: TriangleWidget(
                            color: Colors.white,
                            size: Size(4, 14),
                            direction: TriangleDirection.right)),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class _SkillBody extends StatelessWidget {
  const _SkillBody({
    required this.actions,
    this.selectedGroupIndex,
    this.selectedIndex,
    this.onSelectedGroup,
    required this.headerBackgroundColor,
    required this.bodyBackgroundColor,
    required this.compact,
  });

  final List<RoveAction> actions;
  final int? selectedGroupIndex;
  final int? selectedIndex;
  final Function(int)? onSelectedGroup;
  final Color headerBackgroundColor;
  final Color bodyBackgroundColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: const Alignment(0, -0.4),
        child: ActionListWidget(
          actions: actions,
          selectedGroupIndex: selectedGroupIndex,
          selectedActionIndex: selectedIndex,
          onSelectedGroup: onSelectedGroup,
          actionBuilder: (_, __) => (true, null),
          borderColor: headerBackgroundColor,
          backgroundColor: bodyBackgroundColor,
          fontSize: 10,
          compact: compact,
        ));
  }
}

class _SkillSubheader extends StatelessWidget {
  const _SkillSubheader({
    required this.type,
    required this.subtype,
    required this.backgroundColor,
    required this.child,
  });

  final String type;
  final String subtype;
  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 35),
        child: Container(
            width: double.infinity,
            color: backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: const Alignment(0.6, 0),
                  width: 60,
                  child: CardShadow(
                    child: RoveIcon(type, height: 20),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.grey,
                    child: Center(child: child),
                  ),
                ),
                Container(
                  alignment: const Alignment(-0.6, 0),
                  width: 60,
                  child: CardShadow(
                    child: RoveIcon(subtype, height: 20),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class _SkillHeader extends StatelessWidget {
  const _SkillHeader({
    required this.backgroundColor,
    required this.cardName,
    required this.upgrade,
  });

  final Color backgroundColor;
  final String cardName;
  final bool upgrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      alignment: const Alignment(0.0, 0.8),
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          if (upgrade)
            Container(
              alignment: const Alignment(0.6, 0),
              width: 60,
              child: const CardShadow(
                child: RoveIcon('damage', height: 20),
              ),
            ),
          Expanded(
            child: Center(
              child: CardShadow(
                child: RoveText.subtitle(cardName, textAlign: TextAlign.center),
              ),
            ),
          ),
          if (upgrade)
            Container(
              alignment: const Alignment(-0.6, 0),
              width: 60,
              child: const CardShadow(
                child: RoveIcon('damage', height: 20),
              ),
            ),
        ],
      ),
    );
  }
}
