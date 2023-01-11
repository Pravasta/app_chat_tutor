import '../../../controller/auth_controller.dart';
import '../controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final searchController = Get.put(SearchController());
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: AppBar(
          title: const Text('Search'),
          backgroundColor: const Color(0xff1e81b0),
          centerTitle: true,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                onChanged: (value) => searchController.searchFriend(
                  value,
                  authC.user.value.email!,
                ),
                controller: searchController.searchC,
                cursorColor: Colors.blue[900],
                decoration: InputDecoration(
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: Icon(
                        Icons.search,
                        color: Colors.blue[700],
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    hintText: 'Search new friend here ...'),
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => searchController.tempSearch.isEmpty
            ? Center(
                child: SizedBox(
                  width: Get.width * 0.7,
                  height: Get.width * 0.7,
                  child: Lottie.asset("asset/lottie/empty.json"),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: searchController.tempSearch.length,
                itemBuilder: (context, index) => ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.black26,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: searchController.tempSearch[index]['photoUrl'] ==
                              'noimage'
                          ? Image.asset(
                              'asset/logo/noimage.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              searchController.tempSearch[index]['photoUrl'],
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  title: Text(
                    '${searchController.tempSearch[index]['name']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  subtitle: Text(
                    '${searchController.tempSearch[index]['email']}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  trailing: GestureDetector(
                    onTap: () => authC.addNewConnection(
                      searchController.tempSearch[index]['email'],
                    ),
                    child: const Chip(
                      label: Text('Message'),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
