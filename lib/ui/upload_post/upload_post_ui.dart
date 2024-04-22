import 'dart:io';

import 'package:chat_app_firestore/common/colors/common_colors.dart';
import 'package:chat_app_firestore/common/spacing/common_spacing.dart';
import 'package:chat_app_firestore/common/widget/common_elevated_button.dart';
import 'package:chat_app_firestore/common/widget/common_text.dart';
import 'package:chat_app_firestore/common/widget/common_textfield.dart';
import 'package:chat_app_firestore/model/new_post_model.dart';
import 'package:chat_app_firestore/services/firebase_service.dart';
import 'package:chat_app_firestore/ui/all_post/all_post_ui.dart';
import 'package:chat_app_firestore/ui/upload_post/upload_post_cubit.dart';
import 'package:chat_app_firestore/ui/upload_post/upload_post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class UploadPostUi extends StatefulWidget {
  const UploadPostUi({super.key});

  static const String routeName = '/upload_post_ui';
  static Widget builder(BuildContext context) {
    final registerUserId =
    ModalRoute.of(context)?.settings.arguments as String?;
    return BlocProvider(
      create: (context) => UploadPostCubit(
        UploadPostState(
          descriptionController: TextEditingController(),
          locationController: TextEditingController(),
          pickedImageFile: XFile(""),
          registerUserId: registerUserId ?? "",
        ),
      ),
      child: const UploadPostUi(),
    );
  }


  @override
  State<UploadPostUi> createState() => _UploadPostUiState();
}

class _UploadPostUiState extends State<UploadPostUi> {

  UploadPostCubit get newPostCubit => context.read<UploadPostCubit>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const CommonText(text: 'New Post', fontSize: Spacing.xLarge),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: BlocBuilder<UploadPostCubit, UploadPostState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// upload image
                    Padding(
                      padding: PaddingValue.medium,
                      child: GestureDetector(
                        onTap: () {
                          context.read<UploadPostCubit>().imagePicker();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            color: Colors.white,
                          ),
                          child: SizedBox(
                            child: state.pickedImageFile.path.isEmpty
                                ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 150,
                                  color: Colors.grey,
                                ),
                                CommonText(
                                  text: 'Tap to Select Image',
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.grey,
                                  fontSize: 20,
                                )
                              ],
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                File(
                                  state.pickedImageFile.path,
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// enter description
                    const Gap(20),
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15),
                      child: CommonTextField(
                        controller: state.descriptionController,
                        labelText: 'Enter Description',
                        prefixIcon: Icons.description,
                        iconColor: Colors.blue,
                      ),
                    ),

                    /// enter location
                    const Gap(6),
                    Padding(
                      padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 15),
                      child: CommonTextField(
                        controller: state.locationController,
                        labelText: 'Enter location',
                        prefixIcon: Icons.location_on,
                        iconColor: Colors.red,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: PaddingValue.large,
                          child: Center(
                            child: CommonElevatedButton(
                              text: 'Post',
                              onPressed: () async {
                                ///upload image
                                // DataBaseHelper.instance.uploadImages(uploadImagePath: state.pickedImageFile);


                                // newPostCubit.imageUpload(
                                //   uploadImagePath: state.pickedImageFile,
                                //   context: context,
                                // );
                                // Navigator.pushNamed(context, AllPostUi.routeName);



                                if (state.isImageUploaded == false) {
                                  newPostCubit.imageUpload(
                                    uploadImagePath: state.pickedImageFile,
                                    // isImageUploaded: true,
                                    context: context,
                                  );
                                }

                                /// insert post desc, location & image
                                if (state.uploadImage.isNotEmpty) {
                                  FirebaseServices.firebaseInstance.insertNewPost(
                                    newPostModel: NewPostModel(
                                      // userId: state.registerUserId,
                                      imageUrl: state.uploadImage,
                                      description: state.descriptionController.text,
                                      location: state.locationController.text,
                                      isLike: false,
                                    ),
                                  );

                                  Navigator.pushNamed(context, AllPostUi.routeName,
                                      /*arguments: state.pickedImageFile*/);
                                }
                                else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Column(
                                        children: [
                                          CommonText(
                                            text: 'Image is Uploaded...',
                                            textColor: CommonColor.white,
                                          ),
                                          CommonText(
                                            text: '\t\tPlease Wait...',
                                            textColor: CommonColor.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: PaddingValue.large,
                          child: Center(
                            child: CommonElevatedButton(
                              text: 'Cancel',
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
