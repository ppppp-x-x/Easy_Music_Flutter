import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeBanner extends StatelessWidget {
  final bannerList;
  HomeBanner(this.bannerList);
  
  @override
  Widget build(BuildContext context) {
    return bannerList == null
    ?
    Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      color: Colors.grey,
    )
    :
    Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return CachedNetworkImage(
            imageUrl: bannerList[index]['imageUrl'],
            width: MediaQuery.of(context).size.width,
            height: 160,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: MediaQuery.of(context).size.width,
              height: 160,
              color: Colors.grey,
            ),
          );
        },
        itemCount: bannerList.length,
        pagination: SwiperPagination(
          margin: EdgeInsets.only(
            top: 40
          )
        ),
        control: SwiperControl(
          iconNext: null,
          iconPrevious: null
        ),
        autoplay: true,
      )
    );
  }
}