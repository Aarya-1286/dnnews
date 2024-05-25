import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class NewsDetailsScreen extends StatefulWidget {
 final String newsImage,newsTitle,author,description,content;
  const NewsDetailsScreen({Key? key,
  required this.newsImage,
  required this.newsTitle,
  required this.author,
  required this.description,
  required this.content,
  }): super(key:key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.sizeOf(context).width * 1;
    final height=MediaQuery.sizeOf(context).height * 1;
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: height*.45,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
              child: CachedNetworkImage(imageUrl: widget.newsImage,
              fit:BoxFit.cover,
                placeholder: (context,url)=>Center(child: CircularProgressIndicator()),


              ),
                        ),
          ),
          Container(
            height: height*0.6,
            margin: EdgeInsets.only(top:height*.4),
            padding: EdgeInsets.only(top:20,right: 20,left: 20),
            decoration: BoxDecoration(
              color: Colors.white,
            borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(40),
    ),
            ),
            child: ListView(
                 children: [
                 Text(widget.newsTitle, style: TextStyle(fontFamily: 'Anton', fontSize: 30,fontWeight: FontWeight.w700, ),),
                   SizedBox(height: height* .02,),
                   Row(
                     children: [
                       Text(widget.description,style:TextStyle(fontFamily: 'Anton', fontSize: 20,fontWeight: FontWeight.w500, ),),
                       SizedBox(height: height* .02,),
                     ],
                   ),
                   Row(
                     children: [
                       Text(widget.content,style:TextStyle(fontFamily: 'Anton', fontSize: 20,fontWeight: FontWeight.w500,   ), ),
                       SizedBox(height: height* .02,),
                     ],
                   )

              ],
            ),
          )
        ],
      ),
    );
  }
}



