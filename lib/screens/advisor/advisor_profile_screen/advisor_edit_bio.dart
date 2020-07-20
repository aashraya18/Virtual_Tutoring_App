import 'dart:io';
import 'package:android/models/advisor_model.dart';
import 'package:android/services/advisor_database_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/student_database_provider.dart';
import '../../../services/auth_provider.dart';
import '../../../common_widgets/platformExceptionAlertDialog.dart';

class AdvisorEditBio extends StatefulWidget {
  AdvisorEditBio(this.advisor);
  final Advisor advisor;
  @override
  _AdvisorEditBioState createState() => _AdvisorEditBioState();
}

class _AdvisorEditBioState extends State<AdvisorEditBio> {
  final _profileKey = GlobalKey<FormState>();

  // Image Picker instance
  final _picker = ImagePicker();
  File image;

  bool _isSaving = false;

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutController = TextEditingController();


  Future<void> _pickPhoto() async {
    try {
      // Selecting image source
      final _imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (ctx) => Dialog(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                child: Text('Camera'),
                onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              FlatButton(
                child: Text('Gallery'),
                onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      );
      if (_imageSource == null) return;

      // Picking up image from selected source.
      PickedFile pickedimage = await _picker.getImage(source: _imageSource);
      if (pickedimage == null) return;

      // Gives crop option to user.
      image = await ImageCropper.cropImage(
        sourcePath: pickedimage.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Theme.of(context).accentColor,
          activeControlsWidgetColor: Theme.of(context).primaryColor,
          showCropGrid: false,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      );

      // setState for the user to see the selected image.
      // It does not upload image to server.
      setState(() {});
    } catch (error) {
      PlatformExceptionAlertDialog(
        exception: error,
        title: 'Image not picked',
      ).show(context);
    }
  }

  Future<void> _onSaveChanges() async {
    // validate text fields.
    if (!_profileKey.currentState.validate()) return;

    // calls onSaved method in textfields.
    _profileKey.currentState.save();
    setState(() {
      _isSaving = true;
    });
    try {
      // If image is not null update image on server.
      if (image != null) {
        await Provider.of<AdvisorDatabaseProvider>(context, listen: false)
            .updateMyPhotoUrl(image);
      }

      // Update profile on server.
      await Provider.of<AdvisorDatabaseProvider>(context, listen: false)
          .updateMyProfile(
        _nameController.text,
        _aboutController.text,
        _emailController.text,
        _contactController.text,
      );

      // Refreshing User.
      await Provider.of<AuthProvider>(context, listen: false).currentUser();

      _isSaving = false;
      Fluttertoast.showToast(msg: 'Profile Updated');
      Navigator.of(context).pop();
    } catch (error) {
      setState(() {
        _isSaving = false;
        PlatformExceptionAlertDialog(
          exception: error,
          title: 'Image not picked',
        ).show(context);
      });
    }
  }

  @override
  void initState() {
    _nameController.text = widget.advisor.displayName;
    _aboutController.text = widget.advisor.about;
    _emailController.text = widget.advisor.email;
    _contactController.text = widget.advisor.phoneNumber;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final constraints = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _profileKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _buildProfilePicture(constraints, widget.advisor.photoUrl),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: <Widget>[
                    _buildFullNameTTF(),
                    _buildContactTTF(),
                    _buildEmailTTF(),
                    _buildBioTTF(),
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
                  fit: BoxFit.fill,
                  image: image == null
                      ? NetworkImage(imageUrl)
                      : FileImage(image)),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Color.fromRGBO(31, 106, 113, 1),
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onTap: _pickPhoto,
          ),
        ),
      ],
    );
  }

  Widget _buildContactTTF() {
    return TextFormField(
      controller: _contactController,
      decoration: InputDecoration(labelText: 'Contact No'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) return 'Contact cannot be empty';
        return null;
      },
      onSaved: (value) {
        _contactController.text = value;
      },
    );
  }

  Widget _buildFullNameTTF() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(labelText: 'Full Name'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) return 'Name cannot be empty';
        return null;
      },
      onSaved: (value) {
        _nameController.text = value;
      },
    );
  }

  Widget _buildBioTTF() {
    return TextFormField(
      controller: _aboutController,
      decoration: InputDecoration(labelText: 'Bio'),
      maxLength: 3000,
      maxLines: 15,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.length < 10) return 'Bio must be greater than 10 char.';
        return null;
      },
      onSaved: (value) {
        _aboutController.text = value;
      },
    );
  }

  Widget _buildEmailTTF() {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        _emailController.text = value;
      },
      validator: (value) {
        if (value.isEmpty) return 'Enter email';
        if (!regex.hasMatch(value)) return 'Enter valid email.';
        return null;
      },
    );
  }

  Widget _changePasswordLink(String email , BuildContext context ){
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed: () async{
          await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
          print('Done');
          Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text('Email sent'),
            duration: Duration(seconds: 3),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                MdiIcons.lockOutline,
//                color: Theme.of(context).primaryColor,
              ),Text(
                'Change Password',
                style: TextStyle(
//                  color: Theme.of(context).primaryColor,
                    fontSize: 20
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      child: Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        height: 50,
        alignment: Alignment.center,
        child: _isSaving
            ? CircularProgressIndicator()
            : Row(
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
      onTap: _onSaveChanges,
    );
  }
}
