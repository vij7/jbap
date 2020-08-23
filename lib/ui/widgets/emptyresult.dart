import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';

class EmptyResultWidget extends StatelessWidget {
  const EmptyResultWidget({
    Key key,
    @required this.image,
    @required this.title,
    this.iconButton,
    this.subtitle,
  }) : super(key: key);

  final String title, subtitle;
  final PackageImage image;
  final IconButton iconButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: EmptyListWidget(
        image: null,
        packageImage: image,
        title: title,
        subTitle: subtitle,
        titleTextStyle: Theme.of(context)
            .typography
            .dense
            .headline6
            .copyWith(color: Color(0xff9da9c7)),
        subtitleTextStyle: Theme.of(context)
            .typography
            .dense
            .bodyText2
            .copyWith(color: Color(0xffabb8d6)),
      ),
    );
  }
}
