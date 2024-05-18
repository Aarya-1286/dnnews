
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dnnews/models/Categories_news_model.dart';
import 'package:dnnews/models/news_channel_headlines_model.dart';
import 'package:dnnews/view/categories_screen.dart';
import 'package:dnnews/view/news_detail_screen.dart';
import 'package:dnnews/view_model/news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList{ bbcNews,aryNews,independent,cnn}
class _HomeScreenState extends State<HomeScreen> {

  NewsViewModel newsViewModel =NewsViewModel();

  FilterList? selectedMenu;
String name='bbc-news';
  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.sizeOf(context).width * 1;
    final height=MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png',
            height:30,
            width:30,
          ),
        ),
        title: Text('News',
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 24, ),
        ),
        actions:[
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon:Icon(Icons.more_vert,color: Colors.black,),
              onSelected: (FilterList item){
                if(FilterList.bbcNews.name==item.name){
                  name =='bbc-news';
                }
                if(FilterList.bbcNews.name==item.name){
                  name =='cnn-news';
                }
              setState(() {
                selectedMenu=item;
              });

              },
              itemBuilder: (context)=> <PopupMenuEntry<FilterList>> [
                PopupMenuItem<FilterList>(
                    value:FilterList.bbcNews ,
                    child: Text('BBC News'),
                ),
                PopupMenuItem<FilterList>(
                  value:FilterList.bbcNews ,
                  child: Text('CNN News'),
                )
              ]
          )

        ],

      ),
      body: ListView(
        children: [
          SizedBox(
            height: height* .55,
            width:width,
            child:FutureBuilder<NewsChannelsHeadlinesModel>(
               future: newsViewModel.fetchNewChannelHeadlinesApi(),
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
                                            overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Anton', fontSize: 30, ),),


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

          ),
          FutureBuilder<CategoriesNewsModel>(
            future: newsViewModel.fetchCategoriesNewsApi('General'),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context,index){

                      return Padding(
                        padding:const EdgeInsets.only(bottom:15),
                        child:Row(
                          children: [
                            ClipRRect(
                              borderRadius:BorderRadius.circular(15), child: CachedNetworkImage(
                              imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                              fit: BoxFit.cover ,
                              height:height*.18,
                              width:width*.3,
                              placeholder: (context,url)=>Container(child:Center(
                                child: SpinKitCircle(
                                    size: 50,
                                    color: Colors.blue
                                ),
                              )
                              ),
                              errorWidget:(context,url,error)=>Icon(Icons.error_outline,color:Colors.red,),
                            ),
                            ),
                            Expanded(
                              child:Container(
                                height:height*.18,
                                padding:EdgeInsets.only(left:15),
                                child:Column(
                                  children: [
                                    Text(snapshot.data!.articles![index].title.toString(),
                                      maxLines:2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Anton', fontSize: 15, ),
                                    )
                                  ],

                                ),
                              ),
                            )
                          ],
                        ),




                      );
                    }

                );
              }
            },
          )
        ],
      ),
    );
  }

}
const spinkit2=SpinKitFadingCircle(
  color:Colors.amber,
  size: 50,

);