import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

///
/// Widget for loading
/// @param context for how it will building.
/// @param loadingText, the text it show when loading. Has a default.
/// @return Return the loading widget.
///
Widget customLoading(BuildContext context, [String loadingText = "Loading"]){
  return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      child: LoadingJumpingLine.square()
  );
}