import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

class CustomRatingBar extends StatelessWidget {
  // Parent's data:
  final Function setRating;

  CustomRatingBar({ required this.setRating });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Rating: '),
        RatingBar.builder(
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setRating(rating.toInt());
          },
        ),
      ],
    );
  }
}
