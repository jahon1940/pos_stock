import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/cubit/user_cubit.dart';

import '../styles/text_style.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state.manager == null) {
          return const Center(
              child: CircularProgressIndicator()); // Показываем загрузку
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: context.width *
                    .15, // или MediaQuery.of(context).size.width * 0.4
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
              //const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
