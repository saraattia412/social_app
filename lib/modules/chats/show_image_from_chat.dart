import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String image;
  const ShowImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
          icon: Icon(
            Icons.arrow_back
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.contain,
          )
        ),
      ),
    );
  }
}
