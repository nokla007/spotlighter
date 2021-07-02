import 'package:flutter/material.dart';

const double kFormFieldSpacing = 20.0;
const Divider kDivider = Divider(
  thickness: 1.5,
  height: 10,
);

SliverToBoxAdapter kSliverText(String text) => SliverToBoxAdapter(
      child: SizedBox(
        height: (text != '') ? 40 : 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
