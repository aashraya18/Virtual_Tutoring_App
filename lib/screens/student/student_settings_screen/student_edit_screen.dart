import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_provider.dart';

class StudentEditScreen extends StatefulWidget {
  static const routeName = '/student-edit';
  @override
  _StudentEditScreenState createState() => _StudentEditScreenState();
}

class _StudentEditScreenState extends State<StudentEditScreen> {
  final _profileKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).student;
    _nameController.text = user.displayName;
    _phoneController.text = user.uid;
    _emailController.text = user.email;
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _profileKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildProfilePicture(constraints, user.photoUrl),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: <Widget>[
                    _buildFullNameTTF(),
                    _buildPhoneTTF(),
                    _buildEmailTTF(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  Widget _buildProfilePicture(Size constraints, String imageUrl) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: constraints.height * 0.20,
            width: constraints.height * 0.20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill, image: NetworkImage(imageUrl)),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Color.fromRGBO(31, 106, 113, 1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFullNameTTF() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(labelText: 'Full Name'),
      keyboardType: TextInputType.text,
    );
  }

  Widget _buildPhoneTTF() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(labelText: 'Phone Number'),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildEmailTTF() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      child: Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.done_outline, color: Colors.white),
            SizedBox(width: 20),
            Text(
              'SAVE CHANGES',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
