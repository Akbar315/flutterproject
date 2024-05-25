import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:umdb/pages/new_popular_page.dart';
import 'package:umdb/pages/new_top_rated_page.dart';

import '../models/movie.dart';

class MovieGridscreen extends StatefulWidget {
  const MovieGridscreen({super.key});

  @override
  State<MovieGridscreen> createState() => _MovieGridscreenState();
}

class _MovieGridscreenState extends State<MovieGridscreen> {
  Future<MovieList>? topRatedMovies;
  Future<MovieList>? futureMovies;

  Future<MovieList> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/popular_movies.json');
    final jsonResponse = json.decode(jsonString);
    return MovieList.fromJson(jsonResponse);
  }

  Future<MovieList> fetchTopRatedMovies() async {
    final response =
    await http.get(Uri.parse('https://movie-api-rish.onrender.com/top-rated'));

    if (response.statusCode == 200) {
      final jsonResponse2 = json.decode(response.body);
      return MovieList.fromJson(jsonResponse2);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  void initState() {
    super.initState();
    futureMovies = loadJsonData();
    topRatedMovies = fetchTopRatedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800], // Changed background color to dark grey
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Increased overall padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0), // Added more vertical padding for section headers
              child: Text(
                'Popular Movies',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), // Changed text color to white
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewPopularMovies()),
                    );
                  },
                  child: Text(
                    'Browse', // Changed 'View All' to 'Browse'
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<MovieList>(
                future: futureMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final movies = snapshot.data?.items ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey[900], // Changed card color to dark grey
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(movies[index].title,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), // Changed text color to white
                                Text(movies[index].year, style: TextStyle(color: Colors.grey)), // Changed text color to grey
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Top Rated Movies',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewTopRatedMovies()),
                    );
                  },
                  child: Text(
                    'Browse',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<MovieList>(
                future: topRatedMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final topMovies = snapshot.data?.items ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey[900],
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(topMovies[index].title,
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                Text(topMovies[index].year, style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
