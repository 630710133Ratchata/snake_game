import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:snake_game/models/review_item.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  //ดึง API
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<ReviewItem>? _itemList;
  String? _error;

  void getTodos() async {
    try {
      setState(() {
        _error = null;
      });


      final response =
      await _dio.get('http://localhost:3000/reviews');
      debugPrint(response.data.toString());
      // parse
      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => ReviewItem.fromJson(item)).toList();
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar : AppBar(
        title: Center(child: Text("Reviews")),
      ),
      body: Expanded(
        child:ListView.builder(
            itemCount: _itemList!.length,
            itemBuilder: (context,index){
              var reviewItem = _itemList![index];
              return Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(reviewItem.userName),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RatingBar(
                            minRating: 1,
                            maxRating: 5,
                            initialRating: reviewItem.rating,
                            itemSize: 30,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              half: Icon(
                                Icons.star_half,
                                color: Colors.amber,
                              ),
                              empty: Icon(
                                Icons.star,
                                color: Colors.grey,
                              ),

                            ),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                            onRatingUpdate: (double value) {  },
                          ),
                        ),
                      ],
                    ),
                  ],

                ),
              );
            }
        ),
      ),

    );
  }
}
