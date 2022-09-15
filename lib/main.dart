import 'package:flutter/material.dart';
import 'package:movie_app/data/models/movie_model_impl.dart';
import 'package:movie_app/network/dio_movie_data_agent_impl.dart';
import 'package:movie_app/network/http_movie_data_agent_impl.dart';
import 'package:movie_app/network/retrofit_data_agent_impl.dart';
import 'package:movie_app/network/the_movie_api.dart';
import 'package:movie_app/pages/home_page.dart';
import 'package:movie_app/pages/movie_details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}



