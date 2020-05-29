import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/database_provider.dart';
import '../widgets/helperListViewBuilder.dart';

class StudentCompetitiveScreen extends StatelessWidget {
  static const routeName = '/student-competitive';
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        HelperListViewBuilder(
          title: 'JEE - Advance',
          stream: Provider.of<DatabaseProvider>(context).getHelpers(),
        ),
        HelperListViewBuilder(
          title: 'JEE - Main',
          stream: Provider.of<DatabaseProvider>(context).getHelpers(),
        ),
        HelperListViewBuilder(
          title: 'JEE - Main',
          stream: Provider.of<DatabaseProvider>(context).getHelpers(),
        ),
      ],
    );
  }
}
