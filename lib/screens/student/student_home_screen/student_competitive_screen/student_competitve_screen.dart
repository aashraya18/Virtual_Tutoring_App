import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/database_provider.dart';
import '../widgets/advisorListViewBuilder.dart';

class StudentCompetitiveScreen extends StatelessWidget {
  static const routeName = '/student-competitive';
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AdvisorListViewBuilder(
          title: 'JEE - Advance',
          stream: Provider.of<DatabaseProvider>(context)
              .getFilteredAdvisors('jee-advanced'),
        ),
        AdvisorListViewBuilder(
          title: 'JEE - Main',
          stream: Provider.of<DatabaseProvider>(context)
              .getFilteredAdvisors('jee-mains'),
        ),
        AdvisorListViewBuilder(
          title: 'VITEE',
          stream: Provider.of<DatabaseProvider>(context)
              .getFilteredAdvisors('VITEE'),
        ),
      ],
    );
  }
}
