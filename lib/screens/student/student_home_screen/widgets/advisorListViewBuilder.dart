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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(title),
        ),
        StreamBuilder<List<Advisor>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final helpers = snapshot.data;
              return Container(
                height: 262,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) => AdvisorCard(helpers[index]),
                  itemCount: helpers.length,
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}
