import 'package:flutter/material.dart';

abstract class DynamicSize {
  Size getSize(GlobalKey pagekey);
}

class DynamicSizeImpl extends DynamicSize {
  @override
  Size getSize(GlobalKey<State<StatefulWidget>> pageKey) {
    RenderObject? _pageBox = pageKey.currentContext!.findRenderObject();
    return pageKey.currentContext?.size ?? Size(0, 0);
  }
}
