import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/services.dart';

class AdvisorScheduleScreen extends StatelessWidget {
  static const routeName = '/advisor-schedule';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            await Provider.of<AuthProvider>(context, listen: false).signOut();
          },
          child: Text('data'),
        ),
      ),
    );
  }
}
