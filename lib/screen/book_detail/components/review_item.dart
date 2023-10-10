import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/blocs.dart';
import '../../../model/models.dart';

class ReviewItem extends StatelessWidget {
  ReviewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<ReviewBloc, ReviewState>(
            builder: (context, state) {
              if(state is ReviewLoading){
               return SizedBox(child: CircularProgressIndicator(),);
              }
              if(state is ReviewLoaded){
                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.reviews.length,
                      itemBuilder: (context,index){
                        return ReviewItemCard(review: state.reviews[index],);
                      }),
                );
              }
              else{
                return SizedBox(child: Text('Something went wrong'),);
              }
              },
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: ElevatedButton(
                onPressed: (){},
                child: const Text('ADD REVIEWS', style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
}

class ReviewItemCard extends StatelessWidget {
  final Review review;
  const ReviewItemCard({
    super.key, required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width - 50,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Theme.of(context).colorScheme.primary)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: ClipOval(child: Image.asset('assets/image/quote_image_1.png'),),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.userId, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text(review.rating.toString()),
                Expanded(flex: 2, child: Text(review.content, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)))
              ],
            ),
          ),
        ],
      ),
    );
  }
}