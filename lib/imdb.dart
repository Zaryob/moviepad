import 'package:flutter/material.dart';
import 'context_page.dart';


class IMBDListItem extends StatefulWidget {
  const IMBDListItem({
    this.thumbnail,
    this.title,
    this.publisher,
    this.starCount,
  });

  final String thumbnail;
  final String title;
  final String publisher;
  final int starCount;

  @override
  _IMBDListItemState createState() => _IMBDListItemState();
}

class _IMBDListItemState extends State<IMBDListItem> {
  /*
  void _handleTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PublishmentDetailsPage(widget.detailsElement)),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: _handleTap,
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: widget.thumbnail.isNotEmpty
                ? ThumbnailImage(widget.thumbnail)
                : Container(
                    decoration: const BoxDecoration(color: Colors.blue),
                  ),
          ),
          Expanded(
            flex: 3,
            child: _IMBDItemDescription(
              title: widget.title,
              user: widget.publisher,
              starCount: widget.starCount,
            ),
          ),
          const Icon(
            Icons.more_vert,
            size: 16.0,
          ),
        ],
      ),
    ));
  }
}

class _IMBDItemDescription extends StatelessWidget {
  const _IMBDItemDescription({
    Key key,
    this.title,
    this.user,
    this.starCount,
  }) : super(key: key);

  final String title;
  final String user;
  final int starCount;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).accentColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            user,
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          StarDisplayWidget(
            value: starCount,
            filledStar: Icon(Icons.star, color: Colors.orange, size: 28),
            unfilledStar: Icon(Icons.star_border, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}

class StarDisplayWidget extends StatelessWidget {
  final int value;
  final Widget filledStar;
  final Widget unfilledStar;

  const StarDisplayWidget({
    Key key,
    this.value = 0,
    @required this.filledStar,
    @required this.unfilledStar,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return index < value ? filledStar : unfilledStar;
      }),
    );
  }
}

class ThumbnailImage extends StatelessWidget {
  ThumbnailImage(this.imageUrl);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
