import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'deatil.dart';
import 'model/news_model.dart';
import 'package:intl/intl.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  // Define the NewsModel as model
  NewsModel? model;

  @override
  void initState() {
    super.initState();
    // Fetch the data in the initial point
    fetchData();
  }

  // Fetch data function
  Future<void> fetchData() async {
    const String apiUrl =
        'https://timesofindia.indiatimes.com/rssfeedstopstories.cms';

    try {
      final Response response = await get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Xml2Json xml2json = Xml2Json();
        xml2json.parse(response.body);
        final String jsonData = xml2json.toGData();

        setState(() {
          model = NewsModel.fromJson(jsonDecode(jsonData));
        });
        debugPrint("Done");
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception error: $e');
    }
  }

  // Function to print JSON data
  void printJsonData() {
    if (model != null) {
      debugPrint(model!.toJson().toString());
    } else {
      debugPrint('Model is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("India News"),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: model == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: model!.rss.channel.item.length,
                itemBuilder: (context, index) {
                  final newsItem = model!.rss.channel.item[index];
                  // Parse pubDate string into a DateTime object
                  final pubDate =
                      // HH:mm:ss Z
                      DateFormat('EEE, dd MMM yyyy HH:mm:ss Z')
                          .parse(newsItem.pubDate.t);
                  // Formatting the data how we want
                  final formattedDate =
                      DateFormat.yMMMMd().add_jm().format(pubDate);

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Detailpage(
                            newsItem: newsItem,
                            formattedDate: formattedDate, formateDate: '',
                            // formateDate : formattedDate
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: newsItem.enclosure.url,
                          // placeholder: (context, url) =>
                          //     const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: 90,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          newsItem.title.t,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              formattedDate,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
