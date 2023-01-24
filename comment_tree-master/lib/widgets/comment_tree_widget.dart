import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './comment_child_widget.dart';
import './root_comment_widget.dart';
import './tree_theme_data.dart';

typedef AvatarWidgetBuilder<T> = PreferredSize Function(
  BuildContext context,
  T value,
);
typedef ContentBuilder<T> = Widget Function(BuildContext context, T value);

class CommentTreeWidget<R, C> extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = 'CommentTreeWidget';

  final R root;
  final List<C> replies;

  final AvatarWidgetBuilder<R>? avatarRoot;
  final ContentBuilder<R>? contentRoot;

  final AvatarWidgetBuilder<C>? avatarChild;
  final ContentBuilder<C>? contentChild;
  final TreeThemeData treeThemeData;

  const CommentTreeWidget(
    this.root,
    this.replies, {
    this.treeThemeData = const TreeThemeData(lineWidth: 1),
    this.avatarRoot,
    this.contentRoot,
    this.avatarChild,
    this.contentChild,
  });

  @override
  _CommentTreeWidgetState<R, C> createState() =>
      _CommentTreeWidgetState<R, C>();
}

class _CommentTreeWidgetState<R, C> extends State<CommentTreeWidget<R, C>> {
  int initial = 4;

  @override
  Widget build(BuildContext context) {
    int l = widget.replies.length > initial ? initial : widget.replies.length;
    final PreferredSize avatarRoot = widget.avatarRoot!(context, widget.root);
    return Provider<TreeThemeData>.value(
      value: widget.treeThemeData,
      child: Column(
        children: [
          RootCommentWidget(
            avatarRoot,
            widget.contentRoot!(context, widget.root),
          ),
          for (int i = 0; i < (l ?? widget.replies.length); i++)
            CommentChildWidget(
              isLast: widget.replies.length > initial
                  ? widget.replies.indexOf(widget.replies[i]) == (initial - 1)
                  : widget.replies.indexOf(widget.replies[i]) ==
                      (widget.replies.length > (initial + initial)
                          ? initial
                          : widget.replies.length - 1),
              avatar: widget.avatarChild!(context, widget.replies[i]),
              avatarRoot: avatarRoot.preferredSize,
              content: widget.contentChild!(context, widget.replies[i]),
            ),
          widget.replies.length > initial
              ? GestureDetector(
                  onTap: () {
                    if (initial < 0) {
                      initial = widget.replies.length;
                    } else {
                      initial += initial;
                      setState(() {});
                    }
                  },
                  child: Text(
                    "Show more replies",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ))
              : Container()
        ],
      ),
    );
  }
}
