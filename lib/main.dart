import 'package:flutter/material.dart';
import 'package:movies/helper/movies_provider.dart';
import 'package:movies/screens/details.dart';
import 'package:movies/screens/home.dart';
import 'package:provider/provider.dart';

// void main() => runApp(
//       DevicePreview(
//         builder: (context) => MovieTest(),
//       ),
//     );

void main() => runApp(MovieTest());

class MovieTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Movies(),
        ),
      ],
      child: MaterialApp(
        //builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        home: Home(),
        routes: {
          MovieDetails.id: (context) => MovieDetails(),
        },
      ),
    );
  }
}
