import 'package:flutter/material.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:zpw/modules/face/collection_item.dart';

class HomeDetail extends BaseStatefulWidget {
  HomeDetail({required this.title, required this.id});

  final String title;
  final int id;

  @override
  BaseWidgetState<HomeDetail> getState() => _HomeDetailState();
}

class _HomeDetailState extends BaseWidgetState<HomeDetail> {
  @override
  Widget initDefaultBuild(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          YAppBar(title: widget.title),
          Expanded(
            child: CollectionItem(
              id: widget.id,
            ),
          )
        ],
      ),
    );
  }
}
