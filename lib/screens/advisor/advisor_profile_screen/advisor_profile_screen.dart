import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/services.dart';
import '../../../models/advisor_model.dart';

class AdvisorProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final Advisor advisor = Provider.of<AuthProvider>(context).advisor;
    return advisor == null
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor),
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
            ),
            body: Column(
              children: <Widget>[
                _buildImage(context, advisor.photoUrl),
                _buildName(advisor.displayName),
                Expanded(
                    child: _buildDetails(
                        advisor.about, advisor.phoneNumber, advisor.email)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildEditButton(context),
                    _buildSignOutButton(context),
                  ],
                )
              ],
            ),
          );
  }

  Widget _buildImage(BuildContext context, String photoUrl) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.25,
      width: width,
      color: Color.fromRGBO(253, 176, 94, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: height * 0.20,
            width: height * 0.20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(photoUrl),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildName(String displayName) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Colors.white,
      alignment: Alignment.center,
      child: Text(
        displayName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildDetails(String about, String phoneNumber, String email) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Bio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Text(
                about,
                style: TextStyle(fontSize: 18),
                softWrap: true,
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Contact No: $phoneNumber',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Email Id: $email',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ));
  }

  Widget _buildEditButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Edit Bio',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Sign Out',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
          ),
        ),
        onTap: () async {
          await Provider.of<AuthProvider>(context, listen: false).signOut();
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
