import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:logging/logging.dart';

class AIFeatureScreen extends StatefulWidget {
  const AIFeatureScreen({super.key});
  
  @override
  AIFeatureScreenState createState() => AIFeatureScreenState();
}


class AIFeatureScreenState extends State<AIFeatureScreen> {
  String? _result = '';
  final Logger _logger = Logger('AIFeatureScreen');

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
    
    _logger.info('Model loaded: $res');
  }

  Future<void> classifyImage(String imagePath) async {
    var output = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.5,
      asynch: true,
    );
    setState(() {
      _result = output.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Feature'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_result ?? 'No result'),
            ElevatedButton(
              onPressed: () {
                // Call classifyImage with an example image path
                classifyImage('path/to/image.jpg');
              },
              child: const Text('Classify Image'),
            ),
          ],
        ),
      ),
    );
  }
}
