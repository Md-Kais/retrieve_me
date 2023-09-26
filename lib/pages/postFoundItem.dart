import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:retrieve_me/pages/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:retrieve_me/pages/postLostItem.dart';
import '../Components/my_textfield.dart';
import '../firebase_options.dart';

class PostFoundItemPage extends StatefulWidget {
  @override
  State<PostFoundItemPage> createState() =>
      _PostFoundItemPageState();
}

class _PostFoundItemPageState extends State<PostFoundItemPage> {
  XFile? selectedImage;
  TextEditingController whatWasLost = TextEditingController();
  TextEditingController itemCategory = TextEditingController();
  TextEditingController additionalInfo = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController divisionController = TextEditingController();
  TextEditingController unionVillageController = TextEditingController();
  TextEditingController streetHouseController = TextEditingController();

  void _insertImage() async {
    final selector = ImagePicker();
    final selectedFile = await selector.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      setState(() {
        selectedImage = selectedFile;
      });
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
                          // Lost/Found radio button group
                    Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: DrawerHeader(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PostLostItemPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  ' Lost ',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Checkbox.width * 1.2,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  ' Found ',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Checkbox.width * 2,
                                  ),
                                ),
                              )
                            ],
                          ),
                    ),
                    ),
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
                              child: const Text('Insert Found Product Image', style: TextStyle(
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
                                  type: DateTimePickerType.dateTimeSeparate,
                                  dateMask: 'd MMM, yyyy',
                                  initialValue: DateTime.now().toString(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2099),
                                  icon: Icon(Icons.date_range_sharp),
                                  dateLabelText: 'Date',
                                  style: TextStyle(color: Colors.deepOrangeAccent,
                                    fontWeight: FontWeight.bold,),
                                  timeLabelText: "Hour",
                                  selectableDayPredicate: (date){
                                    return true;
                                  },
                                  onSaved: (value) => {print(value)
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
                              )
                          ),

                          const SizedBox(height: 16),
                          MyTextField(
                            controller: whatWasLost,
                            hintText: '',
                            obscureText: true,
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
                          BackButton(style:  ElevatedButton.styleFrom(
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
                                  onPressed: () => {},
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