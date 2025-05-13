import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Color backgroundColor = Color(0xfffcfdfd);
  final Color textColor = Color(0xFF212121);
  final Color accentColor = Color(0xFFc89b3c);
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  DatabaseReference? _dbRef;
  String? profilePicBase64;
  bool isEmailVerified = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? gender;
  DateTime? dob;

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref('users/${user!.uid}');
    _getUserData();
    isEmailVerified = user?.emailVerified ?? false;
  }

  Future<void> _checkEmailVerification() async {
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;
    setState(() {
      isEmailVerified = user?.emailVerified ?? false;
    });
  }

  Future<void> _getUserData() async {
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>?;
          nameController.text = userData?['name'] ?? '';
          phoneController.text = userData?['phone'] ?? '';
          addressController.text = userData?['address'] ?? '';
          emailController.text = user?.email ?? '';
          gender = userData?['gender'];
          dob = userData?['dob'] != null
              ? (userData?['dob'] as Timestamp).toDate()
              : null;
        });
      }

      _dbRef!.child('profilePicture').once().then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          setState(() {
            profilePicBase64 = event.snapshot.value as String?;
          });
        }
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      await _dbRef!.update({'profilePicture': base64Image});

      setState(() {
        profilePicBase64 = base64Image;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated!')),
      );
    }
  }

  Future<void> _removeProfilePicture() async {
    await _dbRef!.update({'profilePicture': null});
    setState(() {
      profilePicBase64 = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile picture removed.')),
    );
  }

  Future<void> _updateProfile() async {
    if (nameController.text.trim().length < 3 ||
        nameController.text.trim().length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Name must be between 3 and 20 characters.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'gender': gender,
        'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? profilePic = profilePicBase64 != null
        ? MemoryImage(base64Decode(profilePicBase64!))
        : AssetImage('assets/default_profile_pic.png') as ImageProvider;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.instrumentSans(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _getUserData,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: profilePic,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: PopupMenuButton<String>(
                          onSelected: (String value) {
                            if (value == 'Upload') {
                              _pickAndUploadImage();
                            } else if (value == 'Remove') {
                              _removeProfilePicture();
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return ['Upload', 'Remove']
                                .map((String choice) => PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            ))
                                .toList();
                          },
                          icon: CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xffc89b3c),
                            child: Icon(
                              LineAwesomeIcons.pencil_alt_solid,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildTextField('Full Name', nameController,
                      LineAwesomeIcons.user_solid, false,
                      isClearable: true),
                  SizedBox(height: 10),
                  _buildEmailField(),
                  SizedBox(height: 10),
                  _buildPhoneNumberField(),
                  SizedBox(height: 10),
                  _buildGenderSelection(),
                  SizedBox(height: 16),
                  _buildEmailVerificationRow(context),
                  SizedBox(height: 100),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                width: double.infinity,
                color: Colors.white,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffc89b3c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _updateProfile,
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.instrumentSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon, bool isDisabled,
      {bool isMultiLine = false, bool isClearable = false}) {
    return TextFormField(
      controller: controller,
      enabled: !isDisabled,
      maxLines: isMultiLine ? 3 : 1,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: GoogleFonts.instrumentSans(color: Color(0xff212121)),
        prefixIcon: Icon(icon, color: Color(0xff212121)),
        suffixIcon: isClearable && controller.text.isNotEmpty
            ? IconButton(
          icon: Icon(Icons.clear, color: Color(0xff212121)),
          onPressed: () => setState(() => controller.clear()),
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      style: GoogleFonts.instrumentSans(color: Color(0xff212121)),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      enabled: false,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: GoogleFonts.instrumentSans(color: Color(0xff212121)),
        prefixIcon:
        Icon(LineAwesomeIcons.envelope_solid, color: Color(0xff212121)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      style: GoogleFonts.instrumentSans(color: Color(0xff212121)),
    );
  }

  Widget _buildPhoneNumberField() {
    return IntlPhoneField(
      controller: phoneController,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        hintStyle: GoogleFonts.instrumentSans(color: Color(0xff212121)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      initialCountryCode: 'IN',
      onChanged: (phone) {
        print(phone.completeNumber);
      },
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      children: [
        Text('Gender:', style: GoogleFonts.instrumentSans(fontSize: 16)),
        SizedBox(width: 16),
        DropdownButton<String>(
          value: gender,
          hint: Text(
            'Select Gender',
            style: GoogleFonts.instrumentSans(color: Color(0xff212121)),
          ),
          items: ['Male', 'Female', 'Other']
              .map((gender) => DropdownMenuItem(
            value: gender,
            child: Text(
              gender,
              style: GoogleFonts.instrumentSans(
                  color: Color(0xff212121)),
            ),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildEmailVerificationRow(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          isEmailVerified
              ? 'assets/check.png'
              : 'assets/crisis.png',
          width: 20,
          height: 20,
        ),
        SizedBox(width: 10),
        Text(
          isEmailVerified ? 'Email is Verified' : 'Email is not Verified',
          style: GoogleFonts.instrumentSans(
            fontSize: 14,
            color: isEmailVerified ? Colors.green : Colors.red,
          ),
        ),
        Spacer(),
        if (!isEmailVerified)
          TextButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                  context, '/email-verification');
              if (result == 'verified') {
                _checkEmailVerification();
              }
            },
            child: Text(
              'Verify Now',
              style: GoogleFonts.instrumentSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ),
      ],
    );
  }
}
