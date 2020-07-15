import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_provider.dart';
import '../../../models/student_model.dart';
import 'student_edit_screen.dart';

class StudentSettingsScreen extends StatelessWidget {
  static const routeName = '/student-settings';

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    final student = Provider.of<AuthProvider>(context).student;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildAvatarColumn(context, constraints, student),
              _buildListTiles(context, student),
            ],
          ),
        ));
  }

  Widget _buildAvatarColumn(
      BuildContext context, Size constraints, Student student) {
    return Container(
      height: constraints.height * 0.3,
      width: constraints.width,
      color: Color(0xff42858C),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: constraints.height * 0.15,
            width: constraints.height * 0.15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill, image: NetworkImage(student.photoUrl)),
            ),
          ),
          SizedBox(height: 15),
          Text(
            student.displayName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTiles(BuildContext context, Student student) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: Icon(
              MdiIcons.pencilOutline,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => StudentEditScreen(student)));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              'Sign Out',
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
            },
          )
        ],
      ),
    );
  }
}