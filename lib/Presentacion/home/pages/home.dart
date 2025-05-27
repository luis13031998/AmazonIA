import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotifymusic_app/Presentacion/home/widgets/news_songs.dart';
import 'package:spotifymusic_app/Presentacion/home/widgets/play_list.dart';
import 'package:spotifymusic_app/common/helpers/is_dark.dart';
import 'package:spotifymusic_app/common/widgets/appbar/app_bar.dart';
import 'package:spotifymusic_app/core/configs/assets/app_images.dart';
import 'package:spotifymusic_app/core/configs/assets/app_vector.dart';
import 'package:spotifymusic_app/core/configs/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

 @override
 void initState(){
  super.initState();
  _tabController = TabController(length: 4, vsync: this);
 }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: SvgPicture.asset(
          AppVector.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _homeTopCard(),
            _tabs(),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: _tabController,
                children: [
                 const NewsSongs(),
                 Container(),
                 Container(),
                 Container()
                ],
              ),
            ),
            const SizedBox(height: 40,),
            const PlayList()
          ],
        ),
      ),
    );
  }

  Widget _homeTopCard(){
    return Center(
      child: Container(
        height: 188,
        child: Stack(
          children: [
             Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                AppVector.homeTopCard
              ),
            ),

             Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                padding: const EdgeInsets.only(
                  right: 60
                ),
                
               child: Image.asset(
                AppImages.homeArtist
                ),
               ),
              )
          ],
        ),
      ),
    );
  }

  Widget _tabs(){
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: context.isDarkMode ? Colors.white : Colors.black,
      indicatorColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 16
      ),
      tabs: const [
        Text(
          'News',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16
          ),
        ),
        Text(
          'Videos',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16
          ),
        ),
        Text(
          'Artist',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16
          ),
        ),
        Text(
          'Podcast',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16
          ),
        )
      ],
    );
  }
}

