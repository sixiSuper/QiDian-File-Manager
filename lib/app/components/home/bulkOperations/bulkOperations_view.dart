// ...
// 批量操作弹窗
// ...

import 'package:bulk_renaming_flutter/app/components/home/bulkOperations/bulkOperations_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/home/filesListTime.dart';
import '../../general/alertDialog/dialogView_view.dart';
import '../../general/button/button.dart';

class BulkOperations extends GetView<BulkOperationsController> {
  final RxList<FilesListTime> allFilesList;
  const BulkOperations({super.key, required this.allFilesList});

  // 调用弹窗方法
  static bulkOperations(
    BuildContext context,
    RxList<FilesListTime> allFilesList, // 传入全部文件列表
  ) {
    return dialogView(
      context,
      btnText: '确认上传',
      btnIcon: Icons.file_upload_outlined,
      child: BulkOperations(allFilesList: allFilesList),
    );
  }

  // 抬头区域
  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('批量操作',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSecondary,
            )),

        // 关闭按钮
        IconButton(
          // 隐藏反馈效果
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,

          // 点击事件
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: Icon(
            Icons.clear_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24,
          ),
        ),
      ],
    );
  }

  // 内容部分
  Widget _body(BuildContext context) {
    return Flexible(
        child: SizedBox(
            width: 400,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('第一步：生成 Excel 模板', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                  const SizedBox(height: 15),
                  SizedBox(
                      width: 123,
                      child: secondaryIconButton(
                        context,
                        label: Text('点击生成', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                        icon: Icons.download_rounded,
                        onPressed: () => controller.downloadTemplate(),
                      )),
                  const SizedBox(height: 10),
                  Text('注：请勿修改模板格式，避免系统无法识别！', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('第二步：上传编辑完成的 Excel 模板文件', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                  const SizedBox(height: 15),
                  SizedBox(
                      width: 123,
                      child: secondaryIconButton(
                        context,
                        label: Text('点击上传', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                        icon: Icons.publish_rounded,
                        onPressed: () => controller.uploadTemplate(),
                      )),
                  const SizedBox(height: 15),

                  // 文件预览区
                  Obx(() => Visibility(
                      visible: controller.selectedPath.isNotEmpty,
                      child: Container(
                        width: 400,
                        height: 30,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          // color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 文件名称
                            Row(children: [
                              Icon(
                                Icons.description_rounded,
                                size: 20,
                                color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),
                              ),
                              const SizedBox(width: 10),
                              Text(controller.selectedName.value,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSecondary,
                                  )),
                            ]),
                            // 删除按钮
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              // 隐藏反馈效果
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,

                              // 点击事件
                              onPressed: () {
                                // 清空路径
                                controller.selectedPath.value = '';
                              },
                              icon: Icon(
                                Icons.clear_rounded,
                                color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ))),
                ]),
              ],
            )));
  }

  // 组件本体
  @override
  Widget build(BuildContext context) {
    controller.context = context;
    controller.allFilesList = allFilesList;
    return SizedBox(
      width: 400,
      height: 500,
      child: Column(children: [
        _header(context),
        _body(context),
        primaryIconButton(
          context,
          label: const Text('上传确认'),
          icon: Icons.file_upload_outlined,

          // 处理函数
          onPressed: () {
            print('ok');
            // 关闭弹窗，pop() 中传入的参数将会作为返回值，需配合异步使用
            controller.uploadData();
            Navigator.pop(context, true);
          },
        ),
      ]),
    );
  }
}
