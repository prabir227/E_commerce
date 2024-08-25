import 'package:flutter/material.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
class ProductDescription extends StatelessWidget{
  String imgUrl="", category="",desc="",title="";
  double price=0.00,rating=0.00;
  ProductDescription(String imgUrl,String category,String desc,String title, double price,double rating){
    this.category = category;
    this.desc=desc;
    this.imgUrl=imgUrl;
    this.title=title;
    this.price = price;
    this.rating = rating;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text(category),
          centerTitle: true,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network(imgUrl,height: 400,width: 500,fit: BoxFit.fill,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              Column(
                children: [Text(title,style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),Text(category),
                  Row(
                    children: [
                      RatingBar.readOnly(
                        size: 25,
                        filledIcon: Icons.star,
                        emptyIcon: Icons.star_border,
                        initialRating: rating,
                        maxRating: 5,
                      ),
                    Text("(${rating})",style: TextStyle(color: Colors.grey))],
                  ),

                ],
              ),
              Text("\$${price.toStringAsFixed(2)}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20))
            ],),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(desc),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(

              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(child: Text("Add to cart",style: TextStyle(color: Colors.white),),
                  onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: Colors.red,),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}