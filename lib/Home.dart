import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visitor_poi_app/widgets/custom_button.dart';
import 'package:visitor_poi_app/widgets/custom_text_field.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController placeController = TextEditingController();

  var places = [];

  @override
  void initState() {
    getPlaces();
    super.initState();
  }

  getPlaces() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? placesStr = prefs.getString('places') ?? '';
    setState(() {
      places = placesStr.split(';');
    });
  }

  addPlace(String place) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      places.add(place);
    });
    prefs.setString('places', places.join(';'));
  }

  editPlace(String newPlace, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      places[index] = newPlace;
    });
    prefs.setString('places', places.join(';'));
  }

  deletePlace(String place, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      places = places.where((e) => e != place).toList();
    });
    prefs.setString('places', places.join(';'));
  }

  handleEditPlace(String place, int index) async {
    placeController.text = place;
    handleAddPlace(context, index);
  }

  handleAddPlace(BuildContext context, int? index) {
    var size = MediaQuery.of(context).size;
    Get.bottomSheet(Container(
      height: size.height * 0.4,
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.5))),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    index == null ? 'Add Place' : 'Edit Place',
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF424242),
                    ),
                  ),
                  GestureDetector(
                    onTap: Get.back,
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextField(
              label: 'Add Place',
              controller: placeController,
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: size.width,
              color: Colors.blue,
              child: CustomButton(
                  label: index == null ? 'Add' : 'Save',
                  onPressed: () {
                    if (placeController.text.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please enter a place!');
                      return;
                    }
                    if (index != null) {
                      editPlace(placeController.text, index);
                    } else {
                      addPlace(placeController.text);
                    }
                    placeController.text = '';
                    Get.back();
                  }),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Places of Interest'),
      ),
      body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          children: places.map((e) {
            var index = places.indexOf(e);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${index + 1}.',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      e,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => handleEditPlace(e, index),
                          child: const SizedBox(
                            width: 25,
                            height: 25,
                            child: Icon(
                              Icons.edit,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () => deletePlace(e, index),
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: Icon(
                              Icons.delete,
                              size: 18,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => handleAddPlace(context, null),
      ),
    );
  }
}
