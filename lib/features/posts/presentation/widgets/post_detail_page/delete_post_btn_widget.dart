import 'package:cleen_acrch_posts_app/core/util/snackbar_message.dart';
import 'package:cleen_acrch_posts_app/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/add_delete_update_post/add_delete_update_post_bloc.dart';
import '../../pages/posts_page.dart';
import 'delete_dialog_widget.dart';

class DeletePostBtnWidget extends StatelessWidget {
  final int postId;
  const DeletePostBtnWidget({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Colors.redAccent,
        ),
      ),
      onPressed: () => deleteDialog(context, postId),
      icon: const Icon(Icons.delete_outline),
      label: const Text("Delete"),
    );
  }

  void deleteDialog(BuildContext context, int postId) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocConsumer<AddDeleteUpdatePostBloc,
              AddDeleteUpdatePostState>(
            listener: (context, state) {
              if (state is MessageAddedDeleteUpdatePostState) {
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const PostsPage(),
                    ),
                    (route) => false);
              } else if (state is ErrorAddedDeleteUpdatePostState) {
                Navigator.of(context).pop();
                SnackBarMessage().showErrorSnackBar(
                    message: state.message, context: context);
              }
            },
            builder: (context, state) {
              if (state is LoadingAddDeleteUpdatePostState) {
                return const AlertDialog(
                  title: LoadingWidget(),
                );
              }
              return DeleteDialogWidget(postId: postId);
            },
          );
        });
  }
}