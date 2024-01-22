import 'package:flutter/material.dart';
import 'StoryCatalog.dart';
import 'chapterPage.dart';
import 'storyPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Final year project',
      //home: storyPage(title: 'Baki The Grappler', chapter: 0),
      //home: ChapterPage(title: 'Baki The Grappler'),
      home: HomePage(),

      // routes: {
      //   '/home' : (context)=>HomePage(),
      //   '/chapterPage': (context)=>ChapterPage(title: title)
      // },

    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'PROTAGONIST',
             style: TextStyle(
               letterSpacing: 2,
             )
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: GridView.builder(
        itemCount: storyCatalog.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index){
            return StoryCard(image: storyCatalog[index].image,
                title: storyCatalog[index].title);
          }),
    );
  }
}


class StoryCard extends StatelessWidget {
  //add reading progress too
  String image;
  String title;
  StoryCard ({super.key, required this.image, required this.title});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        Navigator.push(context,
          MaterialPageRoute(builder: (context)=> ChapterPage(title: title))
        );
      },
      child: Card(
        //margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
        child: Column(
          children: <Widget>[
            Expanded(flex:5, child: Image.network(image)),
            const SizedBox(height: 6.0),
            Expanded(
              flex: 1,
              child: Text(
                  title,
                style: TextStyle(
                  //fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(
        //     color: Colors.white60,
        //   ),
        //   borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
        // ),
      ),
    );
  }
}





