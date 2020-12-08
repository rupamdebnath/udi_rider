import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:udi_rider/AllWidgets/Divider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:udi_rider/Assistants/assistantMethods.dart';
import 'package:udi_rider/DataHandler/appData.dart';
import 'package:udi_rider/AllScreens/searchScreen.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
{
  Completer<GoogleMapController> _controllerMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLogPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLogPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);   //usage of the method from AssistantMethods Class
    print("This is your address :" + address);
  }


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Main Screen")
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile Name", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
                          SizedBox(height: 6.0,),
                          Text("Visit Profile"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              DividerWidget(),

              SizedBox(height: 12.0,),

              //Drawbody controllers
              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 15.0),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("History", style: TextStyle(fontSize: 15.0),),
              ),
            ],
          )
        )
      ),
      body: Stack(
        children: [
          GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller)
              {
                  _controllerMap.complete(controller);
                  newGoogleMapController = controller;

                  setState(() {
                    bottomPaddingOfMap = 300.0;
                  });
                  locatePosition();
              },
          ),

          //Hamburger button for drawer

          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: ()
              {
                  scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 6.0),
                  Text("Nomoskar, Joy Hind", style: TextStyle(fontSize: 12.0),),
                  Text("Where do you want to go?", style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 6.0,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.blueAccent),
                            SizedBox(width: 10.0),
                            Text("Search for drop off location"),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.0,),
                  Row(
                    children: [
                      Icon(Icons.home, color: Colors.grey,),
                      SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Provider.of<AppData>(context).pickupLocation != null
                                ? Provider.of<AppData>(context).pickupLocation.placeName
                                : "Add your home address"    //checking whether pickupLocation has been saved or not
                          ),
                          SizedBox(height: 4.0),
                          Text("Your residential address", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),

                  DividerWidget(),
                  SizedBox(height: 16.0,),

                  Row(
                    children: [
                      Icon(Icons.work, color: Colors.grey,),
                      SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add your work address"),
                          SizedBox(height: 4.0),
                          Text("Your Office address", style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
