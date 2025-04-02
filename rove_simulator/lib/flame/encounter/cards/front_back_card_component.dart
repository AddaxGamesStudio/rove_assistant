import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:rove_simulator/flame/encounter/cards/card_component.dart';

class FrontBackCardComponent extends PositionComponent {
  static final _shadowDecorator = Shadow3DDecorator(
    angle: 0,
    yScale: 1,
    opacity: 0.5,
    blur: 10,
  );
  final CardComponent front;
  CardComponent? back;

  FrontBackCardComponent({required this.front, this.back})
      : super(size: front.size) {
    front.priority = 1;
    back?.priority = 0;
  }

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    add(front);

    front.decorator.addLast(_shadowDecorator);
    back?.decorator.addLast(_shadowDecorator);
  }

  Future<void> showBack() async {
    if (back == null) {
      return;
    }
    add(back!);
    final completer = Completer();
    back!.add(MoveEffect.to(
      Vector2(size.x + 20, 0),
      EffectController(duration: 0.2, curve: Curves.easeOut),
      onComplete: () {
        completer.complete();
      },
    ));
    return completer.future;
  }

  Future<void> hideBack() async {
    if (back == null) {
      return;
    }
    final completer = Completer();
    back!.add(MoveEffect.to(
      Vector2(0, 0),
      EffectController(duration: 0.1, curve: Curves.easeOut),
      onComplete: () {
        back!.removeFromParent();
        completer.complete();
      },
    ));
    return completer.future;
  }
}
