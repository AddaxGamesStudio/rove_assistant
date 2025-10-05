import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rove_assistant/model/encounter/figure.dart';
import 'package:rove_data_types/rove_data_types.dart';

part 'figure_state.g.dart';

@immutable
@JsonSerializable(explicitToJson: true)
class FigureState {
  final int health;
  @JsonKey(name: 'max_health')
  final int maxHealth;
  final int? defense;
  @JsonKey(name: 'round_slain')
  final int? roundSlain;
  final List<String> selectedTokens;
  @JsonKey(name: 'number')
  final int? overrideNumber;
  @JsonKey(defaultValue: false)
  final bool removed;
  @JsonKey(defaultValue: 0)
  final int allyBehaviorIndex;

  const FigureState(
      {required this.health,
      maxHealth,
      this.defense,
      this.roundSlain,
      this.selectedTokens = const [],
      this.overrideNumber,
      this.allyBehaviorIndex = 0,
      this.removed = false})
      : maxHealth = maxHealth ?? health;

  factory FigureState.fromJson(Map<String, dynamic> json) =>
      _$FigureStateFromJson(json);
  Map<String, dynamic> toJson() => _$FigureStateToJson(this);

  factory FigureState.defaultFromFigure(Figure figure) {
    return FigureState(
      health: figure.health,
      maxHealth: figure.maxHealth,
      selectedTokens: figure.selectedTokens,
      allyBehaviorIndex: figure.allyBehaviorIndex,
    );
  }

  FigureState withHealth(int newHealth) {
    return FigureState(
        health: newHealth,
        maxHealth: maxHealth,
        defense: defense,
        roundSlain: roundSlain,
        selectedTokens: selectedTokens,
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: removed);
  }

  FigureState withRemoved() {
    return FigureState(
        health: health,
        maxHealth: maxHealth,
        defense: defense,
        roundSlain: roundSlain,
        selectedTokens: selectedTokens,
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: true);
  }

  FigureState withRespawn() {
    return FigureState(
        health: maxHealth,
        maxHealth: maxHealth,
        defense: defense,
        roundSlain: null,
        selectedTokens: [],
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: false);
  }

  FigureState withMaxHealth(int newMaxHealth) {
    return FigureState(
        health: health,
        maxHealth: newMaxHealth,
        defense: defense,
        roundSlain: roundSlain,
        selectedTokens: selectedTokens,
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: removed);
  }

  FigureState respawn(
      {required health, required defense, bool withoutDie = false}) {
    return FigureState(
        health: health,
        maxHealth: maxHealth,
        defense: defense,
        roundSlain: null,
        selectedTokens: withoutDie
            ? []
            : [
                EtherDieSide
                    .values[Random().nextInt(EtherDieSide.values.length)].name
              ],
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: removed);
  }

  FigureState withDefense(int? newDefense) {
    return FigureState(
        health: health,
        maxHealth: maxHealth,
        defense: newDefense,
        roundSlain: roundSlain,
        selectedTokens: selectedTokens,
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: removed);
  }

  FigureState withRoundSlain(int newRoundSlain) {
    return FigureState(
        health: health,
        maxHealth: maxHealth,
        defense: defense,
        roundSlain: newRoundSlain,
        selectedTokens: selectedTokens,
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: removed);
  }

  FigureState withNumber(int newNumber) {
    return FigureState(
        health: health,
        maxHealth: maxHealth,
        defense: defense,
        roundSlain: roundSlain,
        selectedTokens: selectedTokens,
        overrideNumber: newNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: removed);
  }

  bool get hasOverrideNumber {
    return overrideNumber != null;
  }

  int roundsToRespawnOnRound(int round) {
    if (roundSlain == null) {
      return 0;
    }
    return roundSlain! + roveRoundsToRespawn - round;
  }

  FigureState withTokens(List<String> newTokens) {
    return FigureState(
        health: health,
        maxHealth: maxHealth,
        defense: defense,
        roundSlain: roundSlain,
        selectedTokens: newTokens,
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: removed);
  }

  FigureState withAllyBehaviorIndex(int allyBehaviorIndex) {
    return FigureState(
        health: health,
        maxHealth: maxHealth,
        defense: defense,
        roundSlain: roundSlain,
        selectedTokens: selectedTokens,
        overrideNumber: overrideNumber,
        allyBehaviorIndex: allyBehaviorIndex,
        removed: removed);
  }
}
