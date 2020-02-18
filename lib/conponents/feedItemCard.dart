import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class User {
  final String id;
  final String nickName;
  final String avatar;

  User({this.id, this.nickName, this.avatar});
}

class FeedItemCard extends StatefulWidget {
  FeedItemCard({
    Key key,
    this.id,
    this.content,
    this.video,
    this.videoPoster,
    this.topicName,
    this.type,
    this.topicId,
    this.digCount,
    this.buryCount,
    this.shareCount,
    this.markCount,
    this.commentCount,
    this.imageList,
    this.isFollow,
    this.isMark,
    this.isDig,
    this.isBury,
    this.user,
  }) : super(key: key);

  final String id;
  final String content;
  final String video;
  final String videoPoster;
  final String topicName;
  final int type;
  final int topicId;
  int digCount;
  int buryCount;
  int shareCount;
  int markCount;
  final int commentCount;
  final List imageList;
  bool isFollow;
  bool isMark;
  bool isDig;
  bool isBury;
  User user;

  @override
  FeedItemCardState createState() => FeedItemCardState();
}

class FeedItemCardState extends State<FeedItemCard> {
  VideoPlayerController _videoController;
  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(
        'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  int _starCount = 0;
  void _handleClick() {
    setState(() {
      _starCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: widget.user.avatar == null
                          ? AssetImage(
                              "assets/images/mine_bg.png",
                            )
                          : NetworkImage(
                              widget.user.avatar,
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    Container(
                      height: 25,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.user.nickName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 25,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.content,
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.star),
                        color: Colors.red[500],
                        onPressed: _handleClick,
                      ),
                      Text(widget.markCount.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Text(widget.content),
          ),
          Container(
            child: Image(
              image: NetworkImage(widget.videoPoster),
            ),
          ),
          // Container(
          //   child: _videoController.value.initialized
          //       ? AspectRatio(
          //           aspectRatio: _videoController.value.aspectRatio,
          //           child: VideoPlayer(_videoController),
          //         )
          //       : Container(
          //           height: 400,
          //           decoration: BoxDecoration(
          //             color: Colors.black,
          //           ),
          //         ),
          // ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: Colors.red[500],
                      onPressed: _handleClick,
                    ),
                    Text('2'),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_down),
                      color: Colors.red[500],
                      onPressed: _handleClick,
                    ),
                    Text('踩'),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.sms),
                      color: Colors.red[500],
                      onPressed: _handleClick,
                    ),
                    Text('2'),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      color: Colors.red[500],
                      onPressed: _handleClick,
                    ),
                    Text('2'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeedItemCardContent extends StatefulWidget {
  FeedItemCardContent({
    Key key,
    this.type,
    this.videoPoster,
    this.video,
    this.imageList,
  }) : super(key: key);

  final int type;
  final String videoPoster;
  final String video;
  final List imageList;
  @override
  _FeedItemCardContentState createState() => _FeedItemCardContentState();
}

class _FeedItemCardContentState extends State<FeedItemCardContent> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == 3) {
      return Container(
        child: Image(
          image: NetworkImage(widget.videoPoster),
        ),
      );
    } else if (widget.type == 2) {
      if (widget.imageList.length == 1) {
        return Container(
          child: Image(
            image: NetworkImage(widget.imageList[0]),
          ),
        );
      } else if (widget.imageList.length == 2) {
        return Row(
          children: <Widget>[
            Image(
              image: NetworkImage(widget.imageList[0]),
            ),
            Image(
              image: NetworkImage(widget.imageList[1]),
            ),
          ],
        );
      } else {
        // return Flow(
        //   delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)),
        //   children: widget.imageList.map((e) {
        //     return Image(
        //       image: NetworkImage(e),
        //     );
        //   }).toList(),
        // );
      }
    }
  }
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets margin = EdgeInsets.zero;
  TestFlowDelegate({this.margin});
  @override
  void paintChildren(FlowPaintingContext context) {
    var x = margin.left;
    var y = margin.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      var w = context.getChildSize(i).width + x + margin.right;
      if (w < context.size.width) {
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x = w + margin.left;
      } else {
        x = margin.left;
        y += context.getChildSize(i).height + margin.top + margin.bottom;
        //绘制子widget(有优化)
        context.paintChild(i,
            transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i).width + margin.left + margin.right;
      }
    }
  }

  @override
  getSize(BoxConstraints constraints) {
    //指定Flow的大小
    return Size(double.infinity, 200.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
