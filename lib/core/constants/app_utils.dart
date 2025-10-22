import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

sealed class AppUtils {
  AppUtils._();

  static const double mainSpacing = 10;

  /// gap
  static const Gap kMainObjectsGap = Gap(mainSpacing);
  static const Gap kGap6 = Gap(6);
  static const Gap kGap8 = Gap(8);
  static const Gap kGap12 = Gap(12);
  static const Gap kGap16 = Gap(16);
  static const Gap kGap20 = Gap(20);
  static const Gap kGap24 = Gap(24);

  /// box sliver
  static const kSliverGap8 = SliverGap(8);
  static const kSliverGap12 = SliverGap(12);
  static const kSliverGap16 = SliverGap(16);

  /// padding All
  static const EdgeInsets kPadding = EdgeInsets.zero;
  static const EdgeInsets kPaddingAll2 = EdgeInsets.all(2);
  static const EdgeInsets kPaddingAll6 = EdgeInsets.all(6);
  static const EdgeInsets kPaddingAll10 = EdgeInsets.all(10);
  static const EdgeInsets kPaddingAll12 = EdgeInsets.all(12);
  static const EdgeInsets kPaddingAll16 = EdgeInsets.all(16);
  static const EdgeInsets kPaddingAll24 = EdgeInsets.all(24);

  /// padding All and a side
  static const EdgeInsets kPaddingAll10B0 = EdgeInsets.fromLTRB(10, 10, 10, 0);

  /// padding only
  static const EdgeInsets kPaddingL10 = EdgeInsets.only(left: 10);
  static const EdgeInsets kPaddingL12 = EdgeInsets.only(left: 12);
  static const EdgeInsets kPaddingL24 = EdgeInsets.only(left: 24);
  static const EdgeInsets kPaddingB12 = EdgeInsets.only(bottom: 12);

  /// padding symmetric Hor
  static const EdgeInsets kPaddingHor10 = EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets kPaddingHor12 = EdgeInsets.symmetric(horizontal: 12);

  /// padding symmetric Ver
  static const EdgeInsets kPaddingV12 = EdgeInsets.symmetric(vertical: 12);

  /// padding symmetric HorVer
  static const EdgeInsets kPaddingH8V4 = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const EdgeInsets kPaddingH12V6 = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const EdgeInsets kPaddingH16V10 = EdgeInsets.symmetric(horizontal: 16, vertical: 10);

  /// radius
  static const Radius kRadius = Radius.zero;
  static const Radius kRadius8 = Radius.circular(8);

  /// border radius
  static const BorderRadius kBorderRadius = BorderRadius.zero;
  static const BorderRadius kBorderRadius8 = BorderRadius.all(Radius.circular(8));
  static const BorderRadius kBorderRadius10 = BorderRadius.all(Radius.circular(10));
  static const BorderRadius kBorderRadius12 = BorderRadius.all(Radius.circular(12));

  /// custom
  static const BorderRadius kTableRadius = BorderRadius.all(Radius.circular(8));
}
