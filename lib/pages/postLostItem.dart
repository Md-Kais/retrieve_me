import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:retrieve_me/pages/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:retrieve_me/pages/postFoundItem.dart';
import '../Components/my_textfield.dart';
import '../firebase_options.dart';

class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class PostLostItemPage extends StatefulWidget {
  @override
  State<PostLostItemPage> createState() =>
      _PostLostItemPageState();
}

class _PostLostItemPageState extends State<PostLostItemPage> {
  XFile? selectedImage;
  TextEditingController whatWasLost = TextEditingController();
  TextEditingController itemCategory = TextEditingController();
  TextEditingController additionalInfo = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController unionVillageController = TextEditingController();
  TextEditingController streetHouseController = TextEditingController();
  DateTime? dateTimeController = DateTime.now();

  void _insertImage() async {
    final selector = ImagePicker();
    final selectedFile = await selector.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      setState(() {
        selectedImage = selectedFile;
      });
    }
  }
  bool areAllFieldsFilled() {
    return whatWasLost.text.isNotEmpty &&
        itemCategory.text.isNotEmpty &&
        additionalInfo.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        divisionController.text.isNotEmpty &&
        unionVillageController.text.isNotEmpty &&
        streetHouseController.text.isNotEmpty &&
        selectedImage != null &&
    dateTimeController != null;
  }

  Future<void> submitLostItem() async {
    if(areAllFieldsFilled()) {
      try {
        // Create a Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference collectionReference = firestore.collection(
            'LostProduct');

        Timestamp dateTimeTimestamp = Timestamp.fromDate(dateTimeController!);

        // Define a map with the data to be saved
        Map<String, dynamic> lostItemData = {
          'LostItem': whatWasLost.text,
          'Category': itemCategory.text,
          'DateTime': dateTimeTimestamp,
          'Description': additionalInfo.text,
          'CityLocation': cityController.text,
          'DivisionLocation': divisionController.text,
          'UnionVillageLocation': unionVillageController.text,
          'StreetHouseLocation': streetHouseController.text,
        };
        await collectionReference.add(lostItemData);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Lost Item Posted!', textAlign: TextAlign.center),
            content:
            Text('You have successfully created your Lost Item post!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Okay'),
              ),
            ],
          ),
        );

        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => LoginPage(),
        //   ),
        // );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                content:
                Text('Error submitting lost item info'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Okay'),
                  ),
                ],
              ),
        );
      }
    }
    else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content:
          Text('Please fill all the required fields before submitting!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
              builder: (context, snapshot){
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 45, 44, 46),
                      Color.fromARGB(255, 5, 63, 111)
                    ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Padding(padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                      children: [
                      Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: DrawerHeader(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                child: Text(
                                  ' Lost ',
                                  textScaleFactor: ScaleSize.textScaleFactor(context),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Checkbox.width * 2,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PostFoundItemPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  ' Found ',
                                  textScaleFactor: ScaleSize.textScaleFactor(context),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Checkbox.width * 1,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                      // Lost/Found radio button group

                    const SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: MediaQuery.of(context).size.height * 0.075,
                          child: TextButton(
                          onPressed: _insertImage,
                          style: TextButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shadowColor: Colors.green,
                        ),
                      child: const Text('Insert Lost Product Image', style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      ),
                    const SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Align(
                          alignment: Alignment.center,
                          child: DateTimePicker(
                            // timeFieldWidth: MediaQuery.of(context).size.width * 0.35,
                            type: DateTimePickerType.dateTimeSeparate,  // Adjust the type based on your requirements
                            dateMask: 'd MMM, yyyy',
                            initialValue: DateTime.now().toString(),
                            firstDate: DateTime(2000),  // Adjust the firstDate based on your requirements
                            lastDate: DateTime(2099),
                            icon: Icon(Icons.date_range_sharp),
                            dateLabelText: 'Date',
                            style: TextStyle(
                              color: Colors.deepOrangeAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            timeLabelText: "Hour",
                            selectableDayPredicate: (date) {
                              return true;
                            },
                            onChanged: (value) => {
                              dateTimeController = DateTime.parse(value),
                              // dateTimeController = value as DateTimePicker,
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 156, 178, 197), // Border color
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0), // Border radius
                                ),
                              ),
                            )
                            ,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      MyTextField(
                      controller: whatWasLost,
                      hintText: 'Walton Primo RX7',
                      obscureText: false,
                      prefixIcon: Icons.cases,
                      labelText: 'What was Lost',
                      keyboardType: TextInputType.text,
                      ),
                      const SizedBox(height: 16),
                      MyTextField(
                      controller: itemCategory,
                      hintText: 'Mobile',
                      obscureText: false,
                      prefixIcon: Icons.miscellaneous_services,
                      labelText: 'Item Category',
                      keyboardType: TextInputType.emailAddress,
                      ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // City
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: MyTextField(
                                controller: divisionController,
                                hintText: 'Chittagong',
                                obscureText: false,
                                prefixIcon: Icons.location_city,
                                labelText: 'Division',
                                keyboardType: TextInputType.streetAddress,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]'))
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: MyTextField(
                                controller: cityController,
                                hintText: 'Hathazari',
                                obscureText: false,
                                prefixIcon: Icons.location_city,
                                labelText: 'City',
                                keyboardType: TextInputType.streetAddress,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]'))
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // City
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: MyTextField(
                                controller: streetHouseController,
                                hintText: 'Road no: 3, House no: 7',
                                obscureText: false,
                                prefixIcon: Icons.location_city,
                                labelText: 'Street/House No.',
                                keyboardType: TextInputType.streetAddress,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: MyTextField(
                                controller: unionVillageController,
                                hintText: 'Fatikchhari',
                                obscureText: false,
                                prefixIcon: Icons.location_city,
                                labelText: 'Union/Village',
                                keyboardType: TextInputType.streetAddress,
                              ),
                            )
                          ],
                        ),
                      const SizedBox(height: 16),
                        MyTextField(
                          controller: additionalInfo,
                          hintText: 'Context and description of item',
                          obscureText: false,
                          prefixIcon: Icons.info_outlined,
                          labelText: 'Additional Info',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),

                      BackButton(
                        onPressed:() => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        ),
                          style:  ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                      )),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 16),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.250,
                              child: ElevatedButton(
                                onPressed: submitLostItem,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  // splashFactory: InkRipple.splashFactory,
                                ),
                                child: const Text('Submit', style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Checkbox.width * 0.90,
                                ),
                                ),
                              ),
                            ),
                          ],
                        ),

                    ]
                ),
               ),
              ),
      ),
            // },
          );
              }
      ),
    );
  }
}