import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  CameraController? _cameraController;
  List parameter=['%HRMAX','AVERAGE HR','MINIMUM HR','PEAK HR'];
  List value=[72,76,59,138];
  List units=['%','bpm','bpm','bpm'];
  List<IconData> symbol=[Icons.percent_sharp,Icons.arrow_drop_down,Icons.remove,Icons.arrow_drop_up];

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final direction = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(direction, ResolutionPreset.max);
    await _cameraController!.initialize();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return
      Scaffold(
          body: Stack(
            fit: StackFit.expand,
              children: [
                CameraPreview(_cameraController!),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex:2,
                            child: Text('HEART BEAT', style: TextStyle(fontSize: 30,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,),textAlign:TextAlign.end,),
                          ),
                          Expanded(child: SvgPicture.asset('assets/heartbeat.svg')),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('138', style: TextStyle(fontSize: 20,
                                    fontWeight: FontWeight.bold),),
                                Text('bpm', style: TextStyle(fontSize: 10),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: parameter.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: (
                              Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: Text(parameter[index], style: const TextStyle(fontSize: 30,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),textAlign:TextAlign.end,),
                              ),
                              Expanded(
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Icon(Icons.favorite,color: Colors.redAccent,size: 45,),
                                    Icon(symbol[index],color: Colors.white70,)
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(value[index].toString(), style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold),),
                                    Text(units[index], style: TextStyle(fontSize: 10),),
                                  ],
                                ),
                              ),
                            ],
                          )
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ],
            ),
      );
    }
  }
}
