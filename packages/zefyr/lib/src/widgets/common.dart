// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:notus/notus.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'editable_box.dart';
import 'horizontal_rule.dart';
import 'image.dart';
import 'rich_text.dart';
import 'scope.dart';
import 'theme.dart';
// import 'package:zefyr/src/widgets/attr_delegate.dart';

/// Image Information
class ImageInfo extends InfoBase {
  final String url;

  ImageInfo({this.url});
}

/// Video Information
class VideoInfo extends InfoBase {
  final String url;

  VideoInfo({this.url});
}

/// Represents single line of rich text document in Zefyr editor.
class ZefyrLine extends StatefulWidget {
  const ZefyrLine({Key key, @required this.node, this.style, this.padding})
      : assert(node != null),
        super(key: key);

  /// Line in the document represented by this widget.
  final LineNode node;

  /// Style to apply to this line. Required for lines with text contents,
  /// ignored for lines containing embeds.
  final TextStyle style;

  /// Padding to add around this paragraph.
  final EdgeInsets padding;

  @override
  _ZefyrLineState createState() => _ZefyrLineState();
}

class _ZefyrLineState extends State<ZefyrLine> {
  final LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    final scope = ZefyrScope.of(context);
    if (scope.isEditable) {
      ensureVisible(context, scope);
    }
    final theme = Theme.of(context);

    Widget content;
    if (widget.node.hasEmbed) {
      content = buildEmbed(context, scope);
    } else {
      assert(widget.style != null);
      if (widget.node.children.isNotEmpty) {
        final TextNode segment = widget.node.children.first;
        if (segment.style.contains(NotusAttribute.link)) {
          return FutureBuilder(
              future: extract(segment.style.get(NotusAttribute.link).value),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return  ZefyrRichText(
                                  node: widget.node,
                                  text: buildText(context, scope),
                                );
                }
                if (snapshot.hasError) {
                  return ZefyrRichText(
                    node: widget.node,
                    text: buildText(context, scope),
                  );
                }

                if (snapshot.hasData) {
                  var data = snapshot.data;
                  if (data?.title==null || data?.description==null || data?.url==null) {
                    return ZefyrRichText(
                      node: widget.node,
                      text: buildText(context, scope),
                    );
                }

                final attrs = segment.style;
                GestureRecognizer recognizer;

                if (attrs.contains(NotusAttribute.link)) {
                  final tapGestureRecognizer = TapGestureRecognizer();
                  tapGestureRecognizer.onTap = () {
                    // print('delegate: ${scope.attrDelegate}');
                    if (scope.attrDelegate?.onLinkTap != null) {
                      scope.attrDelegate.onLinkTap(attrs.get(NotusAttribute.link).value);
                    }
                  };
                  recognizer = tapGestureRecognizer;
                }

                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if(data?.image!=null&&data?.image!='')
                        Expanded(
                          flex:1,
                          child: CachedNetworkImage(imageUrl: data.image)),
                        SizedBox(width:4),
                        
                        Expanded(
                          flex: 4,
                                                  child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(data?.title!=null&&data?.title!='')
                              RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text:TextSpan(
                                  text: data?.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                   recognizer: recognizer,
                                )
                              ),
                              if(data?.description!=null&&data?.description!=''&&data?.description!=segment.style.get(NotusAttribute.link).value)
                              Text(data?.description,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    // color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                              ZefyrRichText(
                                  node: widget.node,
                                  text: buildText(context, scope),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ZefyrRichText(
                  node: widget.node,
                  text: buildText(context, scope),
                );
              });
          // print(data
          //     .description); // Flutter is Google's UI toolkit for crafting beautiful...

          // print(data.image);
          // print(segment.style.get(NotusAttribute.link).value);

          // return Container(
          //   child: FlutterLinkPreview(
          //     url: segment.style.get(NotusAttribute.link).value,
          //     key: ValueKey(segment.value),
          //     builder: (_info) {
          //       if (_info == null || _info.title == '') {
          //         return ZefyrRichText(
          //           node: widget.node,
          //           text: buildText(context, scope),
          //         );
          //       } else {
          //         if (_info is ImageInfo) {
          //           return CachedNetworkImage(
          //             imageUrl: (_info as ImageInfo).url,
          //             fit: BoxFit.contain,
          //           );
          //         }

          //         final hasDescription =
          //             WebAnalyzer.isNotEmpty(_info.description);
          //         final Color iconColor = Colors.blue;
          //         // print(_info.title);
          //         return Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          //             Row(
          //               children: <Widget>[
          //                 if (WebAnalyzer.isNotEmpty(_info.icon))
          //                   CachedNetworkImage(
          //                     imageUrl: _info.icon,
          //                     fit: BoxFit.contain,
          //                     width: 30,
          //                     height: 30,
          //                   )
          //                 else
          //                   Icon(Icons.link, size: 30, color: iconColor),
          //                 const SizedBox(width: 8),
          //                 Expanded(
          //                   child: Text(
          //                     _info.title,
          //                     overflow: TextOverflow.ellipsis,
          //                     style: TextStyle(
          //                         color: Colors.blue,
          //                         fontSize: 18,
          //                         fontWeight: FontWeight.w600),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             if (hasDescription) const SizedBox(height: 8),
          //             if (hasDescription)
          //               Text(
          //                 _info.description,
          //                 maxLines: 4,
          //                 overflow: TextOverflow.ellipsis,
          //                 style: TextStyle(
          //                     color: Colors.black,
          //                     fontSize: 14,
          //                     fontWeight: FontWeight.normal),
          //               ),
          //           ],
          //         );
          //       }
          //     },
          //   ),
          // );
          // content = ZefyrRichText(
          //   node: widget.node,
          //   text: buildText(context, scope),
          // );

        } else {
          content = ZefyrRichText(
            node: widget.node,
            text: buildText(context, scope),
          );
        }
      } else {
        content = ZefyrRichText(
          node: widget.node,
          text: buildText(context, scope),
        );
      }
    }

    if (scope.isEditable) {
      Color cursorColor;
      switch (theme.platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          cursorColor ??= CupertinoTheme.of(context).primaryColor;
          break;

        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.windows:
        case TargetPlatform.linux:
          cursorColor = theme.cursorColor;
          break;
      }

      content = EditableBox(
        child: content,
        node: widget.node,
        layerLink: _link,
        renderContext: scope.renderContext,
        showCursor: scope.showCursor,
        selection: scope.selection,
        selectionColor: theme.textSelectionColor,
        cursorColor: cursorColor,
      );
      content = CompositedTransformTarget(link: _link, child: content);
    }

    if (widget.padding != null) {
      return Padding(padding: widget.padding, child: content);
    }
    return content;
  }

  void ensureVisible(BuildContext context, ZefyrScope scope) {
    if (scope.selection.isCollapsed &&
        widget.node.containsOffset(scope.selection.extentOffset)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bringIntoView(context);
      });
    }
  }

  String convertUrlToId(String url) {
    // assert(url?.isNotEmpty ?? false, 'Url cannot be empty');
    if (url == '') {
      return '';
    }
    if (url.length == 11) return '';
    url = url.trim();

    for (var exp in [
      RegExp(r'.*watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(r'.*embed\/([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(r'.*youtu\.be\/([_\-a-zA-Z0-9]{11}).*$')
    ]) {
      Match match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return '';
  }


  void bringIntoView(BuildContext context) {
    final scrollable = Scrollable.of(context);
    final object = context.findRenderObject();
    assert(object.attached);
    final viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    final offset = scrollable.position.pixels;
    var target = viewport.getOffsetToReveal(object, 0.0).offset;
    if (target - offset < 0.0) {
      scrollable.position.jumpTo(target);
      return;
    }
    target = viewport.getOffsetToReveal(object, 1.0).offset;
    if (target - offset > 0.0) {
      scrollable.position.jumpTo(target);
    }
  }

  //Dheeraj build to text .. get the zefyrScope.. get the node children and map it into text span
  TextSpan buildText(BuildContext context, ZefyrScope scope) {
    final theme = ZefyrTheme.of(context);
    final children = widget.node.children
        .map((node) => _segmentToTextSpan(node, theme, scope))
        .toList(growable: false);
    return TextSpan(style: widget.style, children: children);
  }

  //Dheeraj ... this is where you are converting segment into text span
  TextSpan _segmentToTextSpan(
      Node node, ZefyrThemeData theme, ZefyrScope scope) {
    final TextNode segment = node;
    final attrs = segment.style;

    GestureRecognizer recognizer;

    if (attrs.contains(NotusAttribute.link)) {
      final tapGestureRecognizer = TapGestureRecognizer();
      tapGestureRecognizer.onTap = () {
        // print('delegate: ${scope.attrDelegate}');
        if (scope.attrDelegate?.onLinkTap != null) {
          scope.attrDelegate.onLinkTap(attrs.get(NotusAttribute.link).value);
        }
      };
      recognizer = tapGestureRecognizer;
    }

    return TextSpan(
      text: segment.value,
      recognizer: recognizer,
      style: _getTextStyle(attrs, theme),
    );
  }

  TextStyle _getTextStyle(NotusStyle style, ZefyrThemeData theme) {
    var result = TextStyle();
    if (style.containsSame(NotusAttribute.bold)) {
      result = result.merge(theme.attributeTheme.bold);
    }
    if (style.containsSame(NotusAttribute.italic)) {
      result = result.merge(theme.attributeTheme.italic);
    }
    if (style.contains(NotusAttribute.link)) {
      result = result.merge(theme.attributeTheme.link);
    }
    return result;
  }

  Widget buildEmbed(BuildContext context, ZefyrScope scope) {
    EmbedNode node = widget.node.children.single;
    EmbedAttribute embed = node.style.get(NotusAttribute.embed);

    if (embed.type == EmbedType.horizontalRule) {
      return ZefyrHorizontalRule(node: node);
    } else if (embed.type == EmbedType.image) {
      return ZefyrImage(node: node, delegate: scope.imageDelegate);
    } else {
      throw UnimplementedError('Unimplemented embed type ${embed.type}');
    }
  }
}
