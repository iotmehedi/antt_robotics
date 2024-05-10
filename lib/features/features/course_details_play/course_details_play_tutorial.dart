import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interective_cares_task/core/utils/consts/textStyle.dart';
import 'package:interective_cares_task/core/utils/extensions/extensions.dart';
import 'package:interective_cares_task/features/features/signup_page/presentation/signup_page.dart';

import '../../../core/routes/route_name.dart';
import '../../../core/routes/router.dart';
import '../../core/common_widgets/video_player_widget/video_player_widget.dart';
import '../signup_page/riverpod_provider/provider.dart';

final singleUrl = StateProvider((ref) => "");
final indexOfVideo = StateProvider((ref) => 0);
final ddd = StateProvider((ref) => 0);
final indexList = StateProvider((ref) => []);
final isFinish = StateProvider((ref) => 0);

class CourseDetailsPlayTutorial extends ConsumerStatefulWidget {
  const CourseDetailsPlayTutorial({super.key});

  @override
  _CourseDetailsPlayTutorialState createState() =>
      _CourseDetailsPlayTutorialState();
}

class _CourseDetailsPlayTutorialState
    extends ConsumerState<CourseDetailsPlayTutorial> {
  var videoList = [];
  Set<int> videoSet = {};
  int zeroCount = 0;

  @override
  Widget build(BuildContext context) {
    final isFinishState = ref.watch(isFinish);

    return WillPopScope(
      onWillPop: () async {
        ref.read(singleUrl.notifier).state = '';
        videoList.clear();
        ref.read(isFinish.notifier).state = 0;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    CollectionReference<Map<String, dynamic>>
                        courseDetailsCollection =
                        FirebaseFirestore.instance.collection('bookmark');
                    DocumentReference<Map<String, dynamic>> docRef =
                        await courseDetailsCollection.add({
                      'image':
                          ref.watch(tutorialTitleName.notifier).state[0].image,
                      'title':
                          ref.watch(tutorialTitleName.notifier).state[0].title,
                      'mentor':
                          ref.watch(tutorialTitleName.notifier).state[0].mentor,
                      'price':
                          ref.watch(tutorialTitleName.notifier).state[0].price,
                      'isBookmarked': true
                      // Add other fields as needed
                    });

                    // Get the ID of the newly added document
                    String documentId = docRef.id;

                    // Now, you can insert data into the nested collection 'video_url_list'
                    CollectionReference<Map<String, dynamic>>
                        videoUrlListCollection = courseDetailsCollection
                            .doc(documentId)
                            .collection('video_url_list');
                    videoUrlListCollection.id;
                    // Insert data into the 'video_url_list' collection
                    for (int i = 0;
                        i < ref.watch(nestedId.notifier).state.length;
                        i++) {
                      await videoUrlListCollection.add({
                        'id': ref.watch(courseLinkList.notifier).state[i].id,
                        'link':
                            ref.watch(courseLinkList.notifier).state[i].link,
                        'isSeen':
                            ref.watch(courseLinkList.notifier).state[i].isSeen,
                        'tutorialNumber': ref
                            .watch(courseLinkList.notifier)
                            .state[i]
                            .tutorialNumber,
                        // Add other fields as needed
                      });
                    }
                    if (!context.mounted) return;
                    snackbar(
                        message: 'Data inserted successfully!',
                        context: context,
                        color: Colors.green);
                  } catch (e) {
                    snackbar(
                        message: e.toString(),
                        context: context,
                        color: Colors.red);
                  }
                },
                icon: const Icon(Icons.bookmark_add_sharp)),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Consumer(builder: (context, ref, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: VideoPlayerScreen(
                        key: UniqueKey(),
                        videoUrls: ref.read(courseLinkList.notifier).state,
                        singleUrl: ref.watch(singleUrl),
                        indexOfVideo: ref.watch(indexOfVideo),
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        var linksList =
                            ref.watch(tutorialTitleName.notifier).state;
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                          child: ListView.builder(
                            itemCount: linksList.length,
                            itemBuilder: (context, index) {
                              var linkItem = linksList[index];

                              return ListTile(
                                title: globalText2(
                                    text: linkItem.title,
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                                subtitle: globalText2(
                                    text: linkItem.mentor,
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal),
                                trailing: globalText2(
                                    text: linkItem.price,
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    5.ph,
                    Expanded(
                      flex: 6,
                      child: Consumer(builder: (context, ref, _) {
                        var isFinishs = ref.watch(isFinish.notifier).state;

                        return ListView.builder(
                          itemCount:
                              ref.watch(courseLinkList.notifier).state.length,
                          itemBuilder: (_, index) {
                            var linksList =
                                ref.watch(courseLinkList.notifier).state[index];

                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    ref.read(singleUrl.notifier).state =
                                        linksList.link;
                                    ref.read(indexOfVideo.notifier).state =
                                        index;
                                    setState(() {});
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(
                                        left: 10, bottom: 5, right: 10),
                                    color: Colors.white,
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 10, bottom: 20),
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            var linksList = ref
                                                .watch(courseLinkList.notifier)
                                                .state;
                                            if (isFinishState != 0 &&
                                                !videoList
                                                    .contains(isFinishState)) {
                                              videoList.add(isFinishState);
                                            }
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                globalText2(
                                                  text:
                                                      "${linksList[index].tutorialNumber}",
                                                  color: Colors.black,
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                linksList[index].isSeen ==
                                                            true ||
                                                        (videoList.contains(
                                                            index + 1))
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 20),
                                                        child: Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green,
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            );
                                          },
                                        )),
                                  ),
                                ),
                                ref
                                                    .watch(
                                                        courseLinkList.notifier)
                                                    .state
                                                    .length -
                                                1 ==
                                            videoList.length &&
                                        ref
                                                    .watch(
                                                        courseLinkList.notifier)
                                                    .state
                                                    .length -
                                                1 ==
                                            index
                                    ? InkWell(
                                        onTap: () {
                                          RouteGenerator.pushNamedAndRemoveAll(
                                              context, Routes.dashboard);
                                          videoList.clear();
                                          ref.read(isFinish.notifier).state = 0;
                                        },
                                        child: Container(
                                          color: Colors.green,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: globalText2(
                                                text: "Claim Your Certificate.",
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            );
                          },
                        );
                      }),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
