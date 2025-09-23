part of 'app_sidebar.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<UserCubit, UserState>(
        builder: (context, state) => state.manager == null
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: context.width * .15,
                      child: Text(
                        state.manager?.name ?? '',
                        style: AppTextStyles.semiType12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppSpace.vertical6,
                    SizedBox(
                      width: context.width * .15,
                      child: Text(
                        "Должность: ${state.manager?.position ?? ''}",
                        style: AppTextStyles.rType12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppSpace.vertical6,
                    SizedBox(
                      width: context.width * .15,
                      child: Text(
                        "Касса: ${state.manager?.pos?.name ?? ''}",
                        style: AppTextStyles.rType12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppSpace.vertical6,
                    SizedBox(
                      width: context.width * .15,
                      child: Text(
                        "Торг. точка: ${state.manager?.pos?.stock?.name ?? ''}",
                        style: AppTextStyles.rType12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
      );
}
