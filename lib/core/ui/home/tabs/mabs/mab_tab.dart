import 'package:event_app/core/models/category_model.dart';
import 'package:event_app/core/providers/app_configprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});
static const String routeName="/map tab";
  @override
  State<MapTab> createState() => _MabTabState();
}

class _MabTabState extends State<MapTab> {
 late Category selectedCategory;
  late List<Category> categories;
  late Function(int) changeSelectedCategory;
  String? _style;
  Future<void> _loadMapStyle() async {
    //rootBundle  بيسمحلك توصل للملفات اللي في ال assets
    final String style = await rootBundle.loadString("assets/map_style.json");

    setState(() {
      _style = style;
    });
  }
  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    var appConfigProvider = Provider.of<AppConfigprovider>(context);
    var size=MediaQuery.of(context).size;
    var height=size.height;
    var width=size.width;
    return Scaffold(
      body: Stack(
        children: [ GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(30.05236, 31.209344),
            zoom: 10,
          
          ),
          //change map style based on theme
          onMapCreated:(GoogleMapController controller)async{
            if(appConfigProvider.isDark()){
            await  controller.setMapStyle(_style);
            }else{
             await   controller.setMapStyle(null); 
            }
        
          },
          polylines: {
            Polyline(
              polylineId: PolylineId('route1'),
              points: [
                LatLng(30.0444, 31.2357), // Cairo
        LatLng(30.1100, 30.9500), 
        LatLng(30.3000, 30.4500), // نص الطريق تقريبًا
        LatLng(30.7000, 30.1000), 
        LatLng(31.0000, 29.9500), 
        LatLng(31.2001, 29.9187), 
              ],
              color: Colors.blue,
              width: 5,
              
            ),
          
          },
          markers: {
            Marker(
              markerId: MarkerId('1'),
              position: LatLng(30.05236, 31.209344),
              infoWindow: InfoWindow(
                title: 'Marker 1',
                
              ),
            ),
            Marker(
              markerId: MarkerId('marker2'),
              position: LatLng(20.06236, 30.219344),
              infoWindow: InfoWindow(
                title: 'Marker 2',
                
              ),
            ),
          },
          
        ),
      
        Positioned(
            bottom: height*0.04,
            left: width*0.01,
            right: 0,
            
          child: SizedBox(
            height: height*0.13,
            child: ListView.separated( 
              scrollDirection: Axis.horizontal,
              itemCount:
                 Category.categories.length,
                 separatorBuilder:  (context, index)=> SizedBox(width: 8,),
                 itemBuilder: (context, index) =>Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: appConfigProvider.isDark()?Colors.black:Colors.white,
                  ),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(Category.categories[index].imagePath,height: height*0.1,width: width*0.3,)),
                          ],
                        ),
                        
                      ),
                    ],
                   ),
                 ),
                 
                 ),
          ),
        ),
          
        
        

      ],
      ),
    );
  }
}
