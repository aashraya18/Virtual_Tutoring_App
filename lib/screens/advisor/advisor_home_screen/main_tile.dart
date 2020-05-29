import 'package:flutter/material.dart';

class MainTile extends StatelessWidget {
  const MainTile({
    @required this.left,
    @required this.top,
    @required this.right,
    @required this.bottom,
    @required this.imageLabel,
    @required this.tileLabel,
    @required this.pageRoute,
  });

  final double left;
  final double top;
  final double right;
  final double bottom;
  final String imageLabel;
  final String tileLabel;
  final String pageRoute;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).accentColor,
            ),
            child: Column(
              children: <Widget>[
                Expanded(child: _buildImage()),
                Divider(
                  color: Theme.of(context).canvasColor,
                  thickness: 3.0,
                ),
                _buildTitle(),
              ],
            ),
          ),
          onTap: () => Navigator.of(context).pushNamed(pageRoute),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/images/$imageLabel',
        fit: BoxFit.scaleDown,
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        tileLabel,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }
}
