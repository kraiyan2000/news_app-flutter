import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model/news_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Detailpage extends StatelessWidget {
  final NewsItem newsItem;
  final String
      formateDate; // Corrected the variable name to match the constructor parameter
  final String formattedDate; // Added formattedDate parameter
  const Detailpage({
    Key? key,
    required this.newsItem,
    required this.formattedDate,
    required this.formateDate, // Added formattedDate parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
        backgroundColor: Colors.black,
      ),
      // backgroundColor: Colors.grey[200],

      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image at the top
              Container(
                child: Image.network(
                  newsItem.enclosure.url,
                  height: 200, // Adjust the height as needed
                  fit: BoxFit.cover,
                ),
              ),
              // Title below the image
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  newsItem.title.t,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18, // Adjust the font size as needed
                  ),
                ),
              ),
              // Description below the title
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      newsItem.description.cdata,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'myFont', // Adjust the font size as needed
                      ),
                    ),
                  ),
                ],
              ),

              // Formatted date below the description
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Date: $formattedDate',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Publisher: ${newsItem.dcCreator.t}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Text(
                formateDate,
              )
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Container(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () {
                      print("pressed");
                      launchUrlString(newsItem.link.t);
                    },
                    child: const Text(
                      'Read full article',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
