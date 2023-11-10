import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qm_dart_ex/qm_dart_ex.dart';
import 'package:qm_widget/style/qm_icon.dart';
import 'package:qm_widget/utils/scale_util.dart';

import '../style/qm_color.dart';

class QMInputWidget extends StatefulWidget {
  final String title;
  final Color titleColor;
  final double? titleWidth;
  final Widget Function(String title)? titleBuilder;
  final String hint;
  final bool enable;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? right;
  final Widget? left;
  final TextAlign textAlign;
  final void Function(String)? onInputChanged;
  final Color bottomBorderColor;
  final EdgeInsets? contentPadding;
  final bool showInputBottomBorder;
  final bool autofocus;
  final int lengthLimiting;
  const QMInputWidget({
    super.key,
    this.title = "",
    this.hint = "",
    this.enable = true,
    this.controller,
    this.keyboardType,
    this.right,
    this.textAlign = TextAlign.left,
    this.onInputChanged,
    this.bottomBorderColor = Colors.white,
    this.titleColor = QMColor.COLOR_030319,
    this.titleWidth,
    this.contentPadding,
    this.left,
    this.showInputBottomBorder = true,
    this.titleBuilder,
    this.autofocus = false,
    this.obscureText = false,
    this.lengthLimiting = 0,
  });

  @override
  State<QMInputWidget> createState() => _QMInputWidgetState();
}

class _QMInputWidgetState extends State<QMInputWidget> {
  Widget buildTextFiled() => TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: widget.enable,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        cursorColor: QMColor.COLOR_030319,
        style: TextStyle(
          color: QMColor.COLOR_030319,
          fontSize: 16.fs,
        ),
        inputFormatters: widget.lengthLimiting > 0
            ? [
                LengthLimitingTextInputFormatter(widget.lengthLimiting),
              ]
            : null,
        textAlign: widget.textAlign,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          contentPadding: widget.contentPadding ?? EdgeInsets.zero,
          isDense: true,
          isCollapsed: true,
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: QMColor.COLOR_BDBDBD,
            fontSize: 16.s,
          ),
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (_) {
          widget.onInputChanged?.call(_);
          setState(() {});
        },
      ).expanded;
  @override
  Widget build(BuildContext context) {
    return [
      widget.title.isNotEmpty.toWidget(
        () =>
            widget.titleBuilder?.call(widget.title) ??
            widget.title
                .toText(
                  color: widget.titleColor,
                  fontSize: 16.fs,
                  height: 24 / 16,
                )
                .applyBackground(
                  width: widget.titleWidth ?? 88.s,
                  margin: EdgeInsets.only(right: 12.s),
                ),
      ),
      [
        [
          widget.left ?? Container(),
          buildTextFiled(),
          (controller.text.isNotEmpty && widget.enable && focusNode.hasFocus)
              .toWidget(
            () => SvgPicture.string(
              QMIcon.inputClear,
              width: 24.s,
              height: 24.s,
            ).onClick(
              click: () {
                controller.clear();
                setState(() {});
              },
            ),
          ),
        ].toRow().expanded
      ]
          .toRow()
          .applyBackground(
            decoration: BoxDecoration(
              border: widget.showInputBottomBorder
                  ? Border(
                      bottom: BorderSide(color: bottomBorderColor, width: 1.s))
                  : null,
            ),
          )
          .expanded,
      widget.right ?? Container(),
    ].toRow();
  }

  late TextEditingController controller =
      widget.controller ?? TextEditingController();
  late FocusNode focusNode = FocusNode();
  Color get bottomBorderColor =>
      focusNode.hasFocus ? QMColor.COLOR_00B276 : widget.bottomBorderColor;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(onInputStateChange);
  }

  void onInputStateChange() {
    setState(() {});
  }

  @override
  void dispose() {
    focusNode.removeListener(onInputStateChange);
    super.dispose();
  }
}
