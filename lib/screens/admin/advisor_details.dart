import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:android/services/advisor_database_provider.dart';
import 'package:android/models/advisor_model.dart';
import 'advisor_tile.dart';
class AllAdvisordetails extends StatelessWidget {
  static const routeName = '/admin_page';
  @override
  Widget build(BuildContext context) {
    //getSlot(context, 'test@test.com', 'ashish@advisor.com');
    return Scaffold(
      body: StreamBuilder<List<String>>(
        stream: Provider.of<AdvisorDatabaseProvider>(context).getAdvisorsList(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            final emailIds = snapshot.data;
            if (emailIds.isNotEmpty) {
              return ListView.builder(
                itemCount: emailIds.length,
                itemBuilder: (context, index) =>
                    FutureBuilder<Advisor>(
                        future: Provider.of<AdvisorDatabaseProvider>(context)
                            .getAdvisor(emailIds[index]),
                        builder: (context, fsnapshot) {
                          if (fsnapshot.hasData) {
                            return BuildTile(advisor: fsnapshot.data,);
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }
                    ),

              );
            } else {
              return Center(child: Text('No Advisors Yet'));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
