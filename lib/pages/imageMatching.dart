import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/Components/navigation_drawer_widget.dart';
import 'package:retrieve_me/firebase_options.dart';
import 'package:retrieve_me/provider/navigation_provider.dart';

GlobalKey<ScaffoldState> _sKey = GlobalKey();

class ImageMatching extends StatelessWidget {
  final String lostItemImageURL;
  final String lostItemName;
  final double lostItemMatchProbability;
  final bool itemLocationMatched;
  const ImageMatching(
      {required this.lostItemImageURL,
      required this.lostItemName,
      required this.lostItemMatchProbability,
      required this.itemLocationMatched});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NavigationProvider(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const SafeArea(
            child: Text(
              'Found Items',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 45, 44, 46),
                    Color.fromARGB(255, 5, 63, 111),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        drawer: const NavigationDrawerWidget(),
        key: _sKey,
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
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
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 173, 197, 199),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            lostItemMatchProbability >= 0.5 &&
                                    itemLocationMatched
                                ? RichText(
                                    text: const TextSpan(
                                    text: 'Item Matched!',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Caveat',
                                      fontSize: 30.0,
                                    ),
                                  ))
                                : RichText(
                                    text: const TextSpan(
                                    text: 'No Items Matched!',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Caveat',
                                      fontSize: 30.0,
                                    ),
                                  )),
                            if (lostItemMatchProbability >= 50.0 &&
                                itemLocationMatched) ...[
                              const SizedBox(height: 10.0),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                child: Image.network(
                                  lostItemImageURL,
                                  fit: BoxFit.cover,
                                  height: 200.0,
                                  width: 200.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                child: Text(
                                  '$lostItemName',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Match Probability: $lostItemMatchProbability',
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
