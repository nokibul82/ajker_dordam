import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'complain_screen.dart';
import '../providers/complains.dart';

class ManualComplainScreen extends StatefulWidget {
  static const routeName = "/manualComplainScreen";
  @override
  _ManualComplainScreenState createState() => _ManualComplainScreenState();
}

class _ManualComplainScreenState extends State<ManualComplainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _shopAddressController = TextEditingController();

  File? _receiptImage;
  File? _shopImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  // Initialize temporary complain
  late Complain _temporaryComplain;

  @override
  void initState() {
    super.initState();
    // Initialize with empty values
    _temporaryComplain = Complain(
      id: '',
      shopId: 'manual', // Set shopId as "manual"
      shopName: '',
      shopImageUrl: '',
      shopAddress: '',
      description: '',
      receiptImageUrl: '',
      dateTime: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageType type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          if (type == ImageType.receipt) {
            _receiptImage = File(pickedFile.path);
          } else {
            _shopImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _takePhoto(ImageType type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          if (type == ImageType.receipt) {
            _receiptImage = File(pickedFile.path);
          } else {
            _shopImage = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take photo: $e')),
      );
    }
  }

  void _showImageSourceDialog(ImageType type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: Theme.of(context).primaryColor),
                title: Text('Gallery', style: TextStyle(color: Theme.of(context).primaryColor)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(type);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera, color: Theme.of(context).primaryColor),
                title: Text('Camera', style: TextStyle(color: Theme.of(context).primaryColor)),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto(type);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _uploadImageToFirebase(File image, String imageType) async {
    try {
      final fileName = '${imageType}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'images/$fileName';
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      throw Exception('Failed to upload $imageType image: $error');
    }
  }

  Future<void> _submitComplain() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a receipt image')),
      );
      return;
    }

    if (_shopImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload a shop image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload both images to Firebase Storage
      final receiptImageUrl = await _uploadImageToFirebase(_receiptImage!, 'receipt');
      final shopImageUrl = await _uploadImageToFirebase(_shopImage!, 'shop');

      // Update temporary complain with form data and image URLs
      final updatedComplain = Complain(
        id: _temporaryComplain.id,
        shopId: 'manual', // Always set shopId as "manual"
        shopName: _shopNameController.text.trim(),
        shopImageUrl: shopImageUrl,
        shopAddress: _shopAddressController.text.trim(),
        description: _descriptionController.text.trim(),
        receiptImageUrl: receiptImageUrl,
        dateTime: DateTime.now(),
      );

      // Set the temporary complain in your provider
      Provider.of<Complains>(context, listen: false).setTemporaryComplain(updatedComplain);

      // Then add the complain
      await Provider.of<Complains>(context, listen: false).addComplain();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Complaint submitted successfully!',style: TextStyle(color: Colors.black),),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate back to complain screen
      Navigator.of(context).pushReplacementNamed(ComplainScreen.routeName);

    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit complaint: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Complaint'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(ComplainScreen.routeName);
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Shop Name Field
                TextFormField(
                  controller: _shopNameController,
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.business, color: primaryColor),
                    labelStyle: TextStyle(color: primaryColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop name';
                    }
                    return null;
                  },
                ),
                Divider(color: primaryColor),
                SizedBox(height: 16),

                // Shop Address Field
                TextFormField(
                  controller: _shopAddressController,
                  decoration: InputDecoration(
                    labelText: 'Shop Address',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.location_on, color: primaryColor),
                    labelStyle: TextStyle(color: primaryColor),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop address';
                    }
                    return null;
                  },
                ),
                Divider(color: primaryColor),
                SizedBox(height: 24),

                // Shop Image Upload Section
                Text(
                  'Shop Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _shopImage == null
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.store, size: 40, color: primaryColor),
                        SizedBox(height: 8),
                        Text('No shop image selected', style: TextStyle(color: primaryColor)),
                      ],
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _shopImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showImageSourceDialog(ImageType.shop),
                        icon: Icon(Icons.upload, color: Colors.white),
                        label: Text('Upload Shop Image', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Description Field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Complaint Description',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.description, color: primaryColor),
                    labelStyle: TextStyle(color: primaryColor),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter complaint description';
                    }
                    if (value.length < 10) {
                      return 'Description must be at least 10 characters long';
                    }
                    return null;
                  },
                ),
                Divider(color: primaryColor),
                SizedBox(height: 24),

                // Receipt Image Upload Section
                Text(
                  'Receipt Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _receiptImage == null
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt, size: 40, color: primaryColor),
                        SizedBox(height: 8),
                        Text('No receipt image selected', style: TextStyle(color: primaryColor)),
                      ],
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _receiptImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showImageSourceDialog(ImageType.receipt),
                        icon: Icon(Icons.upload, color: Colors.white),
                        label: Text('Upload Receipt', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitComplain,
                  child: _isLoading
                      ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Submit Complaint',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ImageType {
  shop,
  receipt,
}