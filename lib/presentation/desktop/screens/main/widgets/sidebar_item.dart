part of 'app_sidebar.dart';

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.onTap,
    required this.label,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.leadingIcon,
    this.trailingIcon,
    this.isSelected = true,
  });

  final VoidCallback onTap;
  final String label;
  final bool isSelected;
  final Widget? leadingIcon;
  final IconData? trailingIcon;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  @override
  Widget build(
    BuildContext context,
  ) =>
      InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(6, 6, 0, 6),
              child: Row(
                children: [
                  if (leadingIcon != null) ...[
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8), border: Border.all(color: context.primary)),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: leadingIcon!,
                        )),
                    label == "" ? SizedBox() : SizedBox(width: 12),
                  ],
                  Text(
                    label,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isSelected ? selectedTextColor : unselectedTextColor,
                      fontSize: 12,
                    ),
                  ),
                  if (trailingIcon != null) ...[
                    Spacer(),
                    Icon(
                      trailingIcon,
                      color: isSelected ? selectedTextColor : unselectedTextColor,
                    ),
                  ],
                ],
              )),
        ),
      );
}
