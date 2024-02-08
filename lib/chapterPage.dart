import 'package:flutter/material.dart';
import 'StoryCollection.dart';
import 'storyPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChapterPage extends StatelessWidget {
  String title;
  int size=0;
  ChapterPage({required this.title}){
      if(story[title]!=null){
        size = story[title]!.length;
      }
      else{
        size = 0;
      }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index){
      return TextButton(
        onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context)=> storyPage(title: title, chapter: index))
          );
        },
        child: Card(
              child: Row(
                children: [
                  Expanded(flex:3, child: Text(story[title]![index][0])),
                  //Expanded(flex:1, child: Image.network(story[title]![index][1]))
                  Expanded(flex:1, child: CachedNetworkImage(
                    imageUrl: story[title]![index][1],
                    placeholder: (context, url) => Image.asset('assets/Placeholder/placeholder.jpg'),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ) )
                ],
              )
            ),
      );
    },
      itemCount: size ,
    );
  }
}

