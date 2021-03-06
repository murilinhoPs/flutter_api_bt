import 'package:challenge_bt_app/app/global/custom/app_colors.dart';
import 'package:challenge_bt_app/app/global/widgets/input_field.dart';
import 'package:challenge_bt_app/app/global/widgets/loading_indicator.dart';
import 'package:challenge_bt_app/app/modules/home/controllers/post_ctrl.dart';
import 'package:challenge_bt_app/app/global/controllers/loading_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';

class PostDialog extends StatelessWidget {
  final _postController = Get.find<PostController>();
  final _loadingController = Get.find<LoadingController>();

  _onSubmit(context) {
    _loadingController.setIsLoading(true);

    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (_postController.methodValue == EnumMethod.POST)
      _postController.createPost();
    else
      _postController.updatePost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 3.0,
          icon: Icon(
            FontAwesome.cancel,
            size: 26.0,
            color: AppColors.textOrange,
          ),
          onPressed: () => _postController.terminatedOperation(),
        ),
        actions: [
          Obx(
            () => _postController.methodValue == EnumMethod.PUT
                ? IconButton(
                    splashRadius: 3.0,
                    icon: Icon(FontAwesome.trash_empty, size: 26.0, color: AppColors.red),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Deletar postagem!',
                        middleText: 'Você tem certeza que quer exluir essa postagem?',
                        backgroundColor: AppColors.lighterBackground,
                        confirm: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(horizontal: 20),
                            ),
                            overlayColor: MaterialStateProperty.all<Color>(AppColors.secondaryRed),
                            backgroundColor: MaterialStateProperty.all<Color>(AppColors.red),
                          ),
                          onPressed: () => _postController.deletePost(),
                          child: Obx(
                            () => _loadingController.isLoading.value
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    child: LoadingIndicator(
                                      color: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                                    ),
                                  )
                                : Text(
                                    'Excluir',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        cancel: TextButton(
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightOrange,
                            ),
                          ),
                          onPressed: () => navigator.pop(),
                        ),
                      );
                    })
                : Container(),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(Get.arguments[0], scale: 2.0),
                      ),
                    ),
                    SizedBox(
                      height: 120,
                      width: Get.context.mediaQuerySize.width * 0.75,
                      child: Obx(
                        () => InputField(
                          expands: true,
                          clearError: _postController.clearErrors,
                          hasError: _postController.canCheckErrorValue,
                          labelText: "Escreva o que quiser",
                          obscureTxt: false,
                          onChanged: _postController.setPostContent,
                          setErrorTxt: _postController.validatePost,
                          initialValue: _postController.postContentValue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  alignment: Alignment.centerRight,
                  height: 70,
                  width: double.infinity,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF393e46),
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 30),
                      ),
                    ),
                    onPressed: () => _onSubmit(context),
                    child: _loadingController.isLoading.value
                        ? Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
                            child: LoadingIndicator(
                              color: AlwaysStoppedAnimation<Color>(AppColors.textWhite),
                            ),
                          )
                        : Text(
                            'Postar',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
