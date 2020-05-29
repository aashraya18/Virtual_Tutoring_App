import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/services.dart';
import '../advisor_profile_screen/advisor_profile_screen.dart';

class ProfileTile extends StatelessWidget {
  void _goToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(AdvisorProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: height * 0.15,
          width: width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Your Profile',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25),
                        ),
                        Text(
                          Provider.of<AuthProvider>(context)
                              .advisor
                              .displayName,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: height * 0.12 - 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(Provider.of<AuthProvider>(context)
                              .advisor
                              .photoUrl)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () => _goToProfile(context),
    );
  }
}
