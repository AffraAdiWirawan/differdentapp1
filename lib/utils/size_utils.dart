
import 'package:flutter/material.dart';


const num widthinit = 390;
const num heightinit = 844;
const num statusbar = 0;


extension ResponsiveExtension on num { 
  double get _width => SizeUtils.width;
  double get _height => SizeUtils.height;
  double get h => ((this * _width) / widthinit);
  double get v =>
      (this * _height) / (heightinit - statusbar); 
  double get adaptSize {
    var height = v;
    var width = h;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }  
  double get fSize => adaptSize;
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    // ignore: unnecessary_this
    return double.parse(this.toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) { 
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType {mobile, tablet, dekstop}

typedef ResponsiveBuild = Widget Function(
  BuildContext context, Orientation orientation, DeviceType deviceType
);

class Sizer extends StatelessWidget {
  // ignore: use_super_parameters
  const Sizer({Key? key, required this.builder}): super(key: key);
  /// Builds the widget whenever the orientation changes.
  final ResponsiveBuild builder;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) { 
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
      });
    }
}
// ignore_for_file: must_be_immutable

class SizeUtils {
  /// Device's BoxConstraints
  static late BoxConstraints boxConstraints;

  /// Device's Orientation
  static late Orientation orientation;

  /// Type of Device
  ///
  /// This can either be mobile or tablet 
  static late DeviceType deviceType;
  /// Device's Height
  static late double height;
  /// Device's Width
  static late double width;

  static void setScreenSize(
    BoxConstraints constraints,
    Orientation currentOrientation,
    ) {
      boxConstraints = constraints;
      orientation = currentOrientation;
      if (orientation == Orientation.portrait) {
        width =
            boxConstraints.maxWidth.isNonZero(defaultValue: widthinit);
        height = boxConstraints.maxHeight.isNonZero();
      } else {
        width =
            boxConstraints.maxHeight.isNonZero(defaultValue: widthinit);
        height = boxConstraints.maxWidth.isNonZero();
      }
      deviceType = DeviceType.mobile;
  }
}