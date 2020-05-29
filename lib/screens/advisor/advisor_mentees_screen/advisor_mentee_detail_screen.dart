import 'package:flutter/material.dart';

class AdvisorMenteeDetailScreen extends StatelessWidget {
  static const routeName = '/mentee-detail';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250,
            backgroundColor: Theme.of(context).accentColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('assets/images/profile2.png'),
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              leading: Image.asset('assets/images/mentee_icon.png'),
              title: Text(
                'Meenal Pandey',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Mentee Info:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Lorem ipsum dolor sit amet, ddjuf kkfkf kk consectetur adipiscing elit, hjfbkll lfnlikkg sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
