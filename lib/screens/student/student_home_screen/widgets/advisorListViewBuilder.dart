import 'package:flutter/material.dart';

import '../../../../models/advisor_model.dart';
import './advisorCard.dart';

class AdvisorListViewBuilder extends StatelessWidget {
  AdvisorListViewBuilder({
    @required this.title,
    @required this.stream,
  });
  final String title;
  final Stream<List<Advisor>> stream;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: height * 0.01),
          child: Text(title),
        ),
        StreamBuilder<List<Advisor>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final helpers = snapshot.data;
              if (helpers.isNotEmpty) {
                return Container(
                  height: height * 0.3,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) => AdvisorCard(helpers[index]),
                    itemCount: helpers.length,
                  ),
                );
              } else {
                return Container(
                  height: height * 0.3,
                  width: width,
                  alignment: Alignment.center,
                  child: Text('No Advisor in this category yet.'),
                );
              }
            } else {
              return Container(
                height: height * 0.3,
                width: width,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
