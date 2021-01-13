import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:stack_view/stack_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static final RandomColor randomColor = RandomColor();
  final colors = List<Color>.generate(100, (index) => randomColor.randomColor(colorHue: ColorHue.blue));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('StackView Example'),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: StackView(
              itemCount: colors.length,
              itemBuilder: (context, index) => CardItem(
                index: index,
                color: colors[index],
              ),
              controller: PageController(),
              scrollDirection: Axis.horizontal,
              stackCount: 3,
              offset: Offset(0, -10),
              scaleFactor: 0.05,
              opacityFactor: 0.20,
              translateFactor: 100,
            ),
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final int index;
  final Color color;

  CardItem({@required this.index, @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 500,
      // width: 10,
      margin: EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[700],
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 96,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.grey[700],
                    blurRadius: 8,
                    offset: Offset(0, 4),
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
