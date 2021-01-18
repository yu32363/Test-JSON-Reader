import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:data_from_server_app/models/ram.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_store/flutter_cache_store.dart';

class RamPage extends StatefulWidget {
  @override
  _RamPageState createState() => _RamPageState();
}

class _RamPageState extends State<RamPage> {
  List<Ram> rams = [];

  @override
  void initState() {
    super.initState();
    loadData('https://www.advice.co.th/pc/get_comp/ram');
  }

  void loadData(String url) async {
    final store = await CacheStore.getInstance();
    final File file = await store.getFile(url);
    final jsonString = json.decode(file.readAsStringSync());
    setState(() {
      jsonString.forEach((v) {
        final ram = Ram.fromJson(v);
        if (ram.ramPriceAdv != 0) rams.add(ram);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Ram Price from Advice JSON'),
      ),
      body: ListView.builder(
          itemCount: rams.length,
          itemBuilder: (context, int i) {
            return GestureDetector(
              onTap: () {},
              child: Column(
                children: [
                  Container(
                    height: 300.0,
                    width: 300.0,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://www.advice.co.th/pic-pc/ram/${rams[i].ramPicture}',
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Text(
                    '${rams[i].ramBrand}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                  ),
                  Text(
                    '${rams[i].ramModel}',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    'Price: ${rams[i].ramPriceAdv} THB',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    color: Colors.deepPurple,
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  )
                ],
              ),
            );
          }),
    );
  }
}
