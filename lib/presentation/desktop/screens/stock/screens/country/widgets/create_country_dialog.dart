import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../data/dtos/country/country_dto.dart';
import '../cubit/country_cubit.dart';

class CreateCountryDialog extends HookWidget {
  const CreateCountryDialog({
    super.key,
    this.country,
  });

  final CountryDto? country;

  @override
  Widget build(
    BuildContext context,
  ) {
    final nameController = useTextEditingController(text: country?.name);
    final fullNameController = useTextEditingController(text: country?.fullName);
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadius12),
      contentPadding: AppUtils.kPaddingAll24,
      content: SizedBox(
        width: context.width * .3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// title
                const Text(
                  'Создания страна производства',
                  style: AppTextStyles.boldType18,
                ),

                /// close button
                CustomSquareIconBtn(
                  Icons.close,
                  size: 48,
                  darkenColors: true,
                  backgrounColor: AppColors.error100,
                  iconColor: AppColors.error600,
                  onTap: () => context.pop(),
                ),
              ],
            ),

            /// content
            AppUtils.kGap24,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///
                AppTextField(
                  label: 'Название',
                  enabledBorderWith: 1,
                  enabledBorderColor: AppColors.stroke,
                  focusedBorderColor: AppColors.stroke,
                  focusedBorderWith: 1,
                  fieldController: nameController,
                ),

                ///
                AppUtils.kGap24,
                AppTextField(
                  label: 'Полное название',
                  enabledBorderWith: 1,
                  enabledBorderColor: AppColors.stroke,
                  focusedBorderColor: AppColors.stroke,
                  focusedBorderWith: 1,
                  fieldController: fullNameController,
                ),

                /// button
                AppUtils.kGap24,
                BlocConsumer<CountryCubit, CountryState>(
                  listenWhen: (p, c) => p.createCountryStatus != c.createCountryStatus,
                  listener: (_, state) {
                    if (state.createCountryStatus.isSuccess || state.createCountryStatus.isError) {
                      context.pop(state.createCountryStatus.isSuccess);
                    }
                  },
                  buildWhen: (p, c) => p.createCountryStatus != c.createCountryStatus,
                  builder: (context, state) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary800,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      if (nameController.text == country?.name && fullNameController.text == country?.fullName) {
                        context.pop();
                        return;
                      }
                      if ((country?.cid ?? '').isNotEmpty) {
                        context.countryBloc.updateCountry(
                          countryCid: country!.cid!,
                          name: nameController.text,
                          fullName: fullNameController.text,
                        );
                      } else {
                        context.countryBloc.createCountry(
                          name: nameController.text,
                          fullName: fullNameController.text,
                        );
                      }
                    },
                    child: state.createCountryStatus.isLoading
                        ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                        : Text(
                            country.isNotNull ? 'Обновить' : 'Создать',
                            style: AppTextStyles.boldType16,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
