import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/database_provider.dart';
import '../widgets/advisorListViewBuilder.dart';

class StudentCollegesScreen extends StatelessWidget {
  static const routeName = '/student-colleges';
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AdvisorListViewBuilder(
          title: 'IIT',
          stream:
              Provider.of<DatabaseProvider>(context).getFilteredAdvisors('IIT'),
        ),
        AdvisorListViewBuilder(
          title: 'NIT',
          stream:
              Provider.of<DatabaseProvider>(context).getFilteredAdvisors('NIT'),
        ),
        AdvisorListViewBuilder(
          title: 'VIT',
          stream:
              Provider.of<DatabaseProvider>(context).getFilteredAdvisors('VIT'),
        ),
      ],
    );
  }
}
