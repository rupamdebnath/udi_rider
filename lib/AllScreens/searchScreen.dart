import 'package:flutter/material.dart';
import 'package:udi_rider/AllWidgets/predictionBox.dart';
import 'package:udi_rider/DataHandler/appData.dart';
import 'package:udi_rider/Models/placePredictions.dart';
import 'package:udi_rider/DataHandler/appData.dart';

import 'package:udi_rider/Assistants/requestAssistant.dart';
import 'package:udi_rider/AllWidgets/Divider.dart';
import 'package:provider/provider.dart';

import '../mapConfig.dart';

class  SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //Text Editing Controllers for both the input boxes
  var pickUpController = TextEditingController();
  var dropOffController = TextEditingController();

  var focusEndPoint = FocusNode();

  bool focused = false;

  void setFocus(){
    if(!focused)
    {
      FocusScope.of(context).requestFocus(focusEndPoint);
      focused = true;
    }

  }

  List<PlacePredictions> mainPredictionList = [];

  void findPlace(String placeName) async
  {
    if(placeName.length > 1)
      {
        String url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:us";

        var res = await RequestAssistant.getRequest(url);
        if(res == 'failed')
        {
          return;
        }

        if(res["status"] == "OK");
        {
          var predictionResponses = res["predictions"];
          var predictionList = (predictionResponses as List).map((e) => PlacePredictions.fromJson(e)).toList();
          //print (predictionList);

          setState(() {
            mainPredictionList = predictionList;
          });

        }

      }
  }

  @override
  Widget build(BuildContext context) {

    String addressForPickup = Provider.of<AppData>(context).pickupLocation.placeName ?? "";
    pickUpController.text = addressForPickup;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
              child: Column(
                children: <Widget>[

                  SizedBox(height: 5,),
                  Stack(
                    children: <Widget>[
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)
                      ),
                      Center(
                        child: Text("Search and set the drop off point", style: TextStyle(fontSize: 20, fontFamily: "bolt-semibold")),
                      ),
                    ],
                  ),

                  SizedBox(height: 18,),

                  Row(
                    children: <Widget>[
                      Image.asset("images/pickicon.png", height: 16, width: 16,),

                      SizedBox(width: 18,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                        ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              controller: pickUpController,
                              decoration: InputDecoration
                                (
                                hintText: "Pickup Location",
                                fillColor: Colors.grey,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 10, top: 8, bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    children: <Widget>[
                      Image.asset("images/desticon.png", height: 16, width: 16,),

                      SizedBox(width: 18,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (value){
                                findPlace(value);
                              },
                              focusNode: focusEndPoint,
                              controller: dropOffController,
                              decoration: InputDecoration(
                                  hintText: "Search for Drop Off Location",
                                  fillColor: Colors.grey,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 10, top: 8, bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          (mainPredictionList.length>0) ?
          ListView.separated(
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index){
              return PredictionBox(mainPredictionList[index]);      //PredictionBox class
            },
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: mainPredictionList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          )
            : Container()
        ],
      ),
    );
  }
}

