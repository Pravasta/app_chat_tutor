import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../updatestatus/views/status_page.dart';
import 'Calls Page/calls_page.dart';
import 'Chats Page/chats.dart';
import 'Community Page/community.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xff1e81b0),
            title: const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                'ChatsApp',
                style: TextStyle(fontSize: 25),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined),
                    iconSize: 30),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: IconButton(
                    onPressed: () => Get.toNamed(Routes.SEARCH),
                    icon: const Icon(Icons.search),
                    iconSize: 30),
              ),
              PopupMenuButton(
                padding: const EdgeInsets.only(top: 10),
                elevation: 4,
                iconSize: 30,
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: InkWell(
                          child: Container(
                              alignment: Alignment.centerLeft,
                              width: Get.width * 0.5,
                              height: 30,
                              child: const Text('Profile',
                                  style: TextStyle(fontSize: 17))),
                          onTap: () => Get.toNamed(Routes.PROFILE))),
                  const PopupMenuItem(value: 2, child: Text('New group')),
                  const PopupMenuItem(value: 3, child: Text('New broadcast')),
                  const PopupMenuItem(value: 4, child: Text('Linked devices')),
                ],
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: Get.width,
              color: const Color(0xff1e81b0),
              child: TabBar(
                isScrollable: false,
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: [
                  Container(
                      width: Get.width * 0.1,
                      color: const Color(0xff1e81b0),
                      child: const Tab(icon: Icon(Icons.groups_rounded))),
                  Container(
                      width: Get.width * 0.3,
                      color: const Color(0xff1e81b0),
                      child: const Tab(text: 'Chats')),
                  Container(
                      width: Get.width * 0.3,
                      color: const Color(0xff1e81b0),
                      child: const Tab(text: 'Status')),
                  Container(
                      width: Get.width * 0.3,
                      color: const Color(0xff1e81b0),
                      child: const Tab(text: 'Calls')),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: TabBarView(
                children: [
                  const CommunityPage(),
                  ChatsApp(),
                  const StatusApp(),
                  const CallsApp(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
