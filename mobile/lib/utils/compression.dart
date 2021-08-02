import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:kmeans/kmeans.dart';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class CompressImage {
  static img.Image? photo;
  static compressingPhoto() async {}

  static void setImageBytes(imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();

    photo = null;
    photo = img.decodeImage(values);
  }

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
  static int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

// FUNCTION

  static Future<Color> _getColor() async {
    Uint8List? data;

    try {
      String coverData = "";
      data = (await NetworkAssetBundle(Uri.parse(coverData)).load(coverData))
          .buffer
          .asUint8List();
    } catch (ex) {
      print(ex.toString());
    }

    setImageBytes(data);

//FractionalOffset(1.0, 0.0); //represents the top right of the [Size].
    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo!.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);
    print("Value of int: $hex ");
    return Color(hex);
  }

  static createCluster(Map<String, List<int>> colorMap) async {
    Color color = await _getColor();
    dynamic reader;
    const int numberOfClusters = 64;
    final trainingSetSize = reader.data.length ~/ 2;
    final List<List<double>> trainingData =
        reader.data.sublist(0, trainingSetSize);
    final KMeans trainingKMeans =
        KMeans(trainingData, labelDim: numberOfClusters);
    final Clusters clustersTrain = trainingKMeans.bestFit(
      minK: 26,
      maxK: 26,
    );

    print(color);
    int trainingErrors = 0;
    for (int i = 0; i < clustersTrain.clusterPoints.length; i++) {
      // Count the occurrences of each label.
      final List<int> counts = List<int>.filled(clustersTrain.k, 0);
      for (int j = 0; j < clustersTrain.clusterPoints[i].length; j++) {
        counts[clustersTrain.clusterPoints[i][j][numberOfClusters].toInt()]++;
      }

      int maxIdx = -1;
      int maxCount = 0;
      for (int j = 0; j < clustersTrain.k; j++) {
        if (counts[j] > maxCount) {
          maxCount = counts[j];
          maxIdx = j;
        }
      }

      for (int j = 0; j < clustersTrain.clusterPoints[i].length; j++) {
        if (clustersTrain.clusterPoints[i][j][numberOfClusters].toInt() !=
            maxIdx) {
          trainingErrors = trainingErrors + 1;
        }
      }
    }

    final Clusters ignoreLabel = Clusters(
      clustersTrain.points,
      <int>[numberOfClusters],
      clustersTrain.clusters,
      clustersTrain.means,
    );

    final List<List<double>> data = reader.data.sublist(trainingSetSize);
    final List<int> predictions = data.map((List<double> point) {
      return ignoreLabel.kNearestNeighbors(point, 5);
    }).toList();

    int errors = 0;
    for (int i = 0; i < predictions.length; i++) {
      final List<double> rep = ignoreLabel.clusterPoints[predictions[i]][0];
      final int repClass = rep[numberOfClusters].toInt();
      final int dataClass = data[i][numberOfClusters].toInt();
      if (dataClass != repClass) {
        errors++;
      }
    }

    final int testSetSize = reader.data.length - trainingSetSize;
    final double errorRate = errors.toDouble() / testSetSize.toDouble();
    print('classification errors: $errors / $testSetSize');
    print('error rate: $errorRate');
  }
}
