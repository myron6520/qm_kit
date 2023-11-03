import 'package:flutter/material.dart';
import 'bool_ex.dart';

extension WidgetEx on Widget {
  Widget onClick({
    required void Function() click,
    bool Function()? willClick,
    void Function()? didClick,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if ((willClick?.call()) ?? true) {
            click.call();
            didClick?.call();
          }
        },
        child: this,
      );
  Widget toCenter() => Center(child: this);
  Widget toAlign({AlignmentGeometry alignment = Alignment.center}) => Align(
        alignment: alignment,
        child: this,
      );
  Widget toPositioned({
    Key? key,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) =>
      Positioned(
        key: key,
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        child: this,
      );
  Widget toPositionedFill({Key? key}) => Positioned.fill(key: key, child: this);
  Widget toRow(
          {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
          CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
          MainAxisSize mainAxisSize = MainAxisSize.max}) =>
      Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [this],
      );
  Widget toColumn(
          {MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
          CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
          MainAxisSize mainAxisSize = MainAxisSize.max}) =>
      Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [this],
      );
  Widget toSafe(
          {bool left = true,
          bool top = true,
          bool right = true,
          bool bottom = true}) =>
      SafeArea(left: left, right: right, top: top, bottom: bottom, child: this);
  Widget toScrollView({
    Axis scrollDirection = Axis.vertical,
    Clip clipBehavior = Clip.hardEdge,
    ScrollPhysics? physics,
  }) =>
      SingleChildScrollView(
        physics: physics,
        scrollDirection: scrollDirection,
        clipBehavior: clipBehavior,
        child: this,
      );
  Widget applyUnconstrainedBox() => UnconstrainedBox(child: this);
  Widget applyPadding(EdgeInsets padding) =>
      Padding(padding: padding, child: this);
  Widget applyBackground(
          {Key? key,
          Color? color,
          double? width,
          double? height,
          BoxConstraints? constraints,
          EdgeInsets? padding,
          EdgeInsets? margin,
          AlignmentGeometry? alignment,
          Clip clipBehavior = Clip.none,
          BoxDecoration? decoration}) =>
      Container(
        key: key,
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        clipBehavior: clipBehavior,
        constraints: constraints,
        color: decoration == null ? color : null,
        alignment: alignment,
        decoration: decoration,
        child: this,
      );
  Widget applyRadius(double radius) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );
  Widget applyOpacity(double opacity) => Opacity(
        opacity: opacity,
        child: this,
      );
  Widget applyTip(String tip) => Tooltip(message: tip, child: this);
  Widget get expanded => Expanded(child: this);
  Widget toExpanded({int flex = 1}) => Expanded(flex: flex, child: this);
  Widget get flexible => Flexible(child: this);
  Widget willPopScope(Future<bool> Function() onWillPop) =>
      WillPopScope(onWillPop: onWillPop, child: this);
  Widget applyCondition(bool condition,
          {Widget? falseWidget, Widget Function()? falseBuilder}) =>
      condition.toWidget(() => this,
          falseWidget: falseWidget, falseBuilder: falseBuilder);
  String get name {
    List<int> nameUnits = runtimeType.toString().codeUnits;
    List<int> codeUnits = [];
    for (var e in nameUnits) {
      if (64 < e && e < 91) {
        codeUnits.addAll("_".codeUnits);
        codeUnits.add(e + 32);
      } else {
        codeUnits.add(e);
      }
    }
    String name = String.fromCharCodes(codeUnits);
    if (name.startsWith("_")) return name.substring(1);
    return name;
  }
}
