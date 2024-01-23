import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../Components/my_textfield.dart';
import '../Components/navigation_drawer_widget.dart';
import '../firebase_options.dart';
import '../provider/navigation_provider.dart';

GlobalKey<ScaffoldState> _sKey = GlobalKey();

class PostFoundItemPage extends StatefulWidget {
  const PostFoundItemPage({super.key});

  @override
  State<PostFoundItemPage> createState() => _PostFoundItemPageState();
}

class _PostFoundItemPageState extends State<PostFoundItemPage> {
  XFile? selectedImage;
  TextEditingController whatWasFound = TextEditingController();
  TextEditingController itemCategory = TextEditingController();
  TextEditingController additionalInfo = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController unionVillageController = TextEditingController();
  TextEditingController streetHouseController = TextEditingController();
  DateTime? dateTimeController = DateTime.now();
  late String imgURL;

  void _insertImage() async {
    final selector = ImagePicker();
    final selectedFile = await selector.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      setState(() {
        selectedImage = selectedFile;
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName = selectedFile.path.split('/').last;
        Reference ref =
            storage.ref().child('images/$fileName${DateTime.now()}');
        print('--------------------------$ref');
        // Reference ref =
        //     storage.ref().child('images/' + DateTime.now().toString());
        UploadTask uploadTask = ref.putFile(File(selectedFile.path));
        print(uploadTask);
        uploadTask.then((res) {
          res.ref.getDownloadURL().then((val) {
            imgURL = val;
            print("Download URL: $imgURL");
          });
        });
      });
    }
  }

  bool areAllFieldsFilled() {
    return whatWasFound.text.isNotEmpty &&
        itemCategory.text.isNotEmpty &&
        additionalInfo.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        divisionController.text.isNotEmpty &&
        unionVillageController.text.isNotEmpty &&
        streetHouseController.text.isNotEmpty &&
        selectedImage != null &&
        dateTimeController != null;
  }

  Future<void> submitFoundItem() async {
    if (areAllFieldsFilled()) {
      try {
        // Create a Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference collectionReference =
            firestore.collection('FoundProduct');

        Timestamp dateTimeTimestamp = Timestamp.fromDate(dateTimeController!);

        // Define a map with the data to be saved
        Map<String, dynamic> foundItemData = {
          'FoundItem': whatWasFound.text,
          'Category': itemCategory.text,
          'DateTime': dateTimeTimestamp,
          'Description': additionalInfo.text,
          'CityLocation': cityController.text,
          'DivisionLocation': divisionController.text,
          'UnionVillageLocation': unionVillageController.text,
          'StreetHouseLocation': streetHouseController.text,
          'ImageURL': imgURL,
        };
        await collectionReference.add(foundItemData);

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title:
                const Text('Found Item Posted!', textAlign: TextAlign.center),
            content: const Text(
                'You have successfully created your Found Item post!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Okay'),
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
          builder: (context) => AlertDialog(
            content: const Text('Error submitting lost item info'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Please fill all the required fields before submitting!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: Scaffold(
        drawer: const NavigationDrawerWidget(),
        key: _sKey,
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
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
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: IconButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(10),
                                    backgroundColor:
                                        const Color.fromARGB(255, 11, 55, 105),
                                  ),
                                  onPressed: () {
                                    _sKey.currentState!.openDrawer();
                                  },
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 30,
                                  )),
                            ),
                            Column(children: [
                              // Lost/Found radio button group
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: DrawerHeader(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Text(
                                          ' Found Item',
                                          style: GoogleFonts.oswald(
                                            textStyle: const TextStyle(
                                              fontSize: 35,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height:
                                    MediaQuery.of(context).size.height * 0.075,
                                child: TextButton(
                                  onPressed: _insertImage,
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.cyan,
                                    shadowColor: Colors.green,
                                  ),
                                  child:
                                      const Text('Insert Found Product Image',
                                          style: TextStyle(
                                            color: Colors.brown,
                                            fontWeight: FontWeight.bold,
                                          )),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: dateTimePicker(),
                                  )),

                              const SizedBox(height: 16),
                              MyTextField(
                                controller: whatWasFound,
                                hintText: '',
                                obscureText: false,
                                prefixIcon: Icons.cases,
                                labelText: 'What was Found',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // City
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: MyTextField(
                                      controller: divisionController,
                                      hintText: 'Chittagong',
                                      obscureText: false,
                                      prefixIcon: Icons.location_city,
                                      labelText: 'Division',
                                      keyboardType: TextInputType.streetAddress,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z. ]'))
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: MyTextField(
                                      controller: cityController,
                                      hintText: 'Hathazari',
                                      obscureText: false,
                                      prefixIcon: Icons.location_city,
                                      labelText: 'City',
                                      keyboardType: TextInputType.streetAddress,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z. ]'))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // City
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: MyTextField(
                                      controller: streetHouseController,
                                      hintText: 'Road no: 3, House no: 7',
                                      obscureText: false,
                                      prefixIcon: Icons.location_city,
                                      labelText: 'Street/House No.',
                                      keyboardType: TextInputType.streetAddress,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
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
                                  style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                              )),
                              const SizedBox(height: 32),
                              submitButton(context),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // },
                );
              }
            }),
      ),
    );
  }

  Row submitButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.350,
          child: ElevatedButton(
            onPressed: submitFoundItem,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              // splashFactory: InkRipple.splashFactory,
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: Checkbox.width * 0.90,
              ),
            ),
          ),
        ),
      ],
    );
  }

  DateTimePicker dateTimePicker() {
    return DateTimePicker(
      // timeFieldWidth: MediaQuery.of(context).size.width * 0.35,
      type: DateTimePickerType.dateTimeSeparate,
      dateMask: 'd MMM, yyyy',
      initialValue: DateTime.now().toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
      icon: const Icon(Icons.date_range_sharp),
      dateLabelText: 'Date',
      style: const TextStyle(
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
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 156, 178, 197), // Border color
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0), // Border radius
          ),
        ),
      ),
    );
  }
}
