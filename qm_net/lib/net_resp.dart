import 'package:flutter/material.dart';
import 'package:qm_dart_ex/extensions/string_ex.dart';
import 'package:qm_dart_ex/extensions/widget_ex.dart';

class NetResp<T> {
  static const int _respOk = 200;
  final T? data;
  final int code;
  final String? msg;
  final Map<dynamic, dynamic>? originalData;
  late bool Function(int code, String? msg) respCheckFunc;
  bool get isOK => respCheckFunc.call(code, msg);
  String get info => "$msg {code:$code}";
  NetResp(
      {this.data,
      this.code = -1,
      this.msg,
      this.originalData,
      bool Function(int code, String? msg)? respCheckFunc}) {
    this.respCheckFunc = respCheckFunc ?? ((c, _) => c == _respOk);
  }
}

enum RespStatus { ready, loading, ok, empty, error }

class RespProvider extends ChangeNotifier {
  RespStatus _status = RespStatus.ready;
  String msg = "";
  int code = 0;

  RespStatus get status => _status;
  set status(RespStatus status) {
    _status = status;
    notifyListeners();
  }

  void commit() {
    notifyListeners();
  }
}

class RespWidget extends StatelessWidget {
  static Widget Function(RespStatus status) defaultStatusWidgetBuilder =
      (status) => status.name.toText(color: Color(0xff666666), fontSize: 13);
  const RespWidget(this.status,
      {Key? key,
      this.sliver = false,
      this.builder,
      this.statusWidgetBuilder,
      this.onTap})
      : super(key: key);
  final bool sliver;
  final Widget Function(BuildContext context)? builder;
  final RespStatus status;
  final Widget? Function(RespStatus status)? statusWidgetBuilder;
  final void Function()? onTap;

  Widget buildStatusWidget() => defaultStatusWidgetBuilder.call(status);
  @override
  Widget build(BuildContext context) {
    if (status == RespStatus.ok) {
      return builder?.call(context) ?? Container();
    }
    var child = statusWidgetBuilder?.call(status) ?? buildStatusWidget();
    var finalChild = sliver ? SliverToBoxAdapter(child: child) : child;
    if (status == RespStatus.loading) {
      return finalChild;
    }
    if (onTap != null) {
      finalChild = finalChild.onClick(click: onTap!);
    }
    return finalChild;
  }
}
