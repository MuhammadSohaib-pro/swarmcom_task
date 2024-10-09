import 'package:flutter/material.dart';
import 'package:stack_board/stack_board_item.dart';

class ColorContent extends StackItemContent {
  ColorContent({required this.color});

  Color color;

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'color': color.value};
  }
}

class ColorStackItem extends StackItem<ColorContent> {
  final BoxShape? shape;
  final Color? strokeColor;
  final double? strokeWidth;
  final Widget? child;
  final bool? strokeFlag;

  ColorStackItem({
    required super.size,
    super.id,
    super.offset,
    super.angle = null,
    super.status = null,
    super.content,
    this.shape,
    this.child,
    this.strokeWidth,
    this.strokeColor,
    this.strokeFlag,
  });

  @override
  StackItem<ColorContent> copyWith({
    Size? size,
    Offset? offset,
    double? angle,
    BoxShape? shape,
    Widget? child,
    StackItemStatus? status,
    bool? lockZOrder,
    ColorContent? content,
    Color? strokeColor,
    double? strokeWidth,
    bool? strokeFlag,
  }) {
    return ColorStackItem(
      id: id,
      size: size ?? this.size,
      offset: offset ?? this.offset,
      angle: angle ?? this.angle,
      status: status ?? this.status,
      shape: shape ?? this.shape,
      child: child ?? this.child,
      content: content ?? this.content,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeFlag: strokeFlag ?? this.strokeFlag,
    );
  }
}
