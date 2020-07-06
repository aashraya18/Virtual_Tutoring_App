import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/student_database_provider.dart';
import '../widgets/advisorListViewBuilder.dart';

class StudentExpertiseScreen extends StatelessWidget {
  static const routeName = '/student-expertise';
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        AdvisorListViewBuilder(
          title: 'Computer Science',
          stream: Provider.of<StudentDatabaseProvider>(context)
              .getFilteredAdvisors('Computer Science'),
        ),
        AdvisorListViewBuilder(
          title: 'Mechanical',
          stream: Provider.of<StudentDatabaseProvider>(context)
              .getFilteredAdvisors('Mechanical'),
        ),
        AdvisorListViewBuilder(
          title: 'Electronics',
          stream: Provider.of<StudentDatabaseProvider>(context)
              .getFilteredAdvisors('Electronics'),
        ),
        AdvisorListViewBuilder(
          title: 'Information Technology',
          stream: Provider.of<StudentDatabaseProvider>(context)
              .getFilteredAdvisors('Information Technology'),
        ),
      ],
    );
  }
}
