import 'package:flutter/material.dart';

import 'package:provider_mvvm_sample/models/entities/entities.dart';
import 'package:provider_mvvm_sample/widgets/widgets.dart';

class ArticleItem extends StatelessWidget {
  final QiitaItem qiitaItem;
  final Function(QiitaItem) onTap;

  ArticleItem({
    @required this.qiitaItem,
    @required this.onTap,
  }): assert(qiitaItem != null);

  Widget _buildTitle() {
    return Text(
      qiitaItem.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600
      ),
    );
  }

  Widget _buildContent() {
    return Text(
      qiitaItem.body,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    );
  }

  Widget _buildBottomWidgets() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // User icon
        UserIcon(qiitaItem.user.profileImageURL),
        // Spacer
        SizedBox(width: 8),
        // User name
        Text(qiitaItem.user.name),
        // Stretch spacer
        Expanded(child: SizedBox()),
        // Likes
        LikesCount(qiitaItem.likes),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: RippleCard(
        height: 140,
        onTap: () {onTap(qiitaItem);},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Title
            _buildTitle(),
            // Spacer
            SizedBox(height: 8),
            // Content
            _buildContent(),
            // Stretch Spacer
            Expanded(child: SizedBox(height: 8)),
            // Bottom
            _buildBottomWidgets(),
          ],
        ),
      ),
    );
  }
}