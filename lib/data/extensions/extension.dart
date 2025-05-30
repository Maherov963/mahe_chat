import 'package:flutter/material.dart';

extension SizedBoxInt on int {
  SizedBox get getWidthSizedBox => SizedBox(
        width: toDouble(),
      );
  SizedBox get getHightSizedBox => SizedBox(
        height: toDouble(),
      );

  ///x*20~= e:19.9=20 *1000
  int getCeilToThousand() => (toInt() / 20).ceil() * 1000;
}

extension SearshFilter on String {
  String getSearshFilter() => replaceAll("أ", "ا")
      .replaceAll("ة", "ه")
      .replaceAll("إ", "ا")
      .replaceAll(" ", "");
}

extension MyDateTime on DateTime {
  String getYYYYMMDD() {
    String day = this.day > 9 ? "${this.day}" : "0${this.day}";
    String month = this.month > 9 ? "${this.month}" : "0${this.month}";
    String year = this.year.toString();
    return "$year-$month-$day";
  }
}

extension MyDirctinality on TextDirection {
  TextDirection get trigDirectionality {
    if (this == TextDirection.ltr) {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }
}
