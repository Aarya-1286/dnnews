





import 'package:cached_network_image/cached_network_image.dart';
import 'package:dnnews/models/Categories_news_model.dart';
import 'package:dnnews/view/home_screen.dart';
import 'package:dnnews/view/news_detail_screen.dart';
import 'package:dnnews/view_model/news_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  NewsViewModel newsViewModel = NewsViewModel();

  String categoryName = 'General';
  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'sports',
    'Business',
    'Technology',
  ];


    @override
  Widget build(BuildContext context) {
    final width=MediaQuery.sizeOf(context).width * 1;
    final height=MediaQuery.sizeOf(context).height * 1;

    return  Scaffold(
      appBar: AppBar(),
      body:Padding(
       padding: const EdgeInsets.symmetric(horizontal: 20),
        child:Column(
        children: [
          SizedBox(
            height:50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesList.length,
                itemBuilder: (context,index) {
                  return InkWell(
                      onTap: () {
                        categoryName = categoriesList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                              color: categoryName == categoriesList[index]
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                                child: Text(categoriesList[index].toString(),style: TextStyle(
                                  fontFamily: 'Anton', fontSize: 30, ))),
                          ),
                        ),
                      )
                  );
                }
          ),
          ),
          SizedBox(height: 20,),
          Expanded(
           child: FutureBuilder<CategoriesNewsModel>(
             future: newsViewModel.fetchCategoriesNewsApi(categoryName),
             builder: (BuildContext context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return Center(
                   child: SpinKitCircle(
                       size: 50,
                       color: Colors.blue
                   ),
                 );
               } else {
                 return ListView.builder(
                     itemCount: snapshot.data!.articles!.length,
                     scrollDirection: Axis.horizontal,
                     itemBuilder: (context,index){
                       DateTime dateTime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                       return InkWell(
                         onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder: (context)=>
                               NewsDetailsScreen(
                                   newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                   newsTitle: snapshot.data!.articles![index].title.toString(),
                                   author: snapshot.data!.articles![index].author.toString(),
                                   description: snapshot.data!.articles![index].description.toString(),
                                   content: snapshot.data!.articles![index].content.toString())),
                           );
                         },

                         child: SizedBox(
                           child: Stack(
                             alignment: Alignment.center,
                             children: [
                               Container(
                                   height:height * 0.6,
                                   width:width * .9,
                                   child:ClipRRect(
                                     borderRadius:BorderRadius.circular(15),
                                     child:CachedNetworkImage(
                                       imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                       fit: BoxFit.cover ,
                                       placeholder: (context,url)=>Container(child:spinkit2,),
                                     ),
                                   )
                               ),
                               Positioned(
                                 bottom: 20,
                                 child:Card(
                                   elevation: 5,
                                   color: Colors.white ,
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   child:Container(
                                     alignment:Alignment.bottomCenter,
                                     height: height * .22,
                                     child:Column(
                                       mainAxisAlignment:MainAxisAlignment.center,
                                       crossAxisAlignment: CrossAxisAlignment.center,
                                       children: [
                                         Container(
                                           width:width*0.7,
                                           child: Text(snapshot.data!.articles![index].title.toString(),
                                             maxLines:2,
                                             overflow: TextOverflow.ellipsis,
                                             style: TextStyle(
                                               fontFamily: 'Anton',
                                               fontSize: 30, ),),


                                         )


                                       ],
                                     ),
                                   ),
                                 ),
                               )
                             ],
                           ),
                         ),
                       );
                     }

                 );
               }
             },
           ),
          )
        ],
      ) ,
    ),
    );
  }
}
