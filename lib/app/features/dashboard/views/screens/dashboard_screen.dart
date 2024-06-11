library dashboard;

import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/features/dashboard/views/components/filters_forms.dart';
import 'package:apartments/app/features/dashboard/views/screens/adding_apartment.dart';

import 'package:apartments/app/shared_components/header_text.dart';
import 'package:apartments/app/shared_components/list_task_assigned.dart';
import 'package:apartments/app/shared_components/list_task_date.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/shared_components/search_field.dart';
import 'package:apartments/app/shared_components/selection_button.dart';
import 'package:apartments/app/shared_components/simple_selection_button.dart';
import 'package:apartments/app/shared_components/simple_user_profile.dart';
import 'package:apartments/app/shared_components/user_profile.dart';
import 'package:apartments/app/utils/helpers/navigation_services.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apartments/app/utils/helpers/app_helpers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../components/task_in_progress.dart';

// binding
part '../../bindings/dashboard_binding.dart';

// controller
part '../../controllers/dashboard_controller.dart';

// model

// component
part '../components/bottom_navbar.dart';
part '../components/header_weekly_task.dart';
part '../components/main_menu.dart';
part '../components/task_menu.dart';
part '../components/member.dart';
// part '../components/task_in_progress.dart';
part '../components/weekly_task.dart';
part '../components/task_group.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scafoldKey,
      drawer: ResponsiveBuilder.isDesktop(context)
          ? null
          : Drawer(
              child: SafeArea(
                child: SingleChildScrollView(child: _buildSidebar(context)),
              ),
            ),
      bottomNavigationBar: (ResponsiveBuilder.isDesktop(context) || kIsWeb)
          ? null
          : const _BottomNavbar(),
      body: SafeArea(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterContent(
                    onPressedMenu: () => controller.openDrawer(),
                  ),
                  _buildTaskContent(
                    onPressedMenu: () => controller.openDrawer(),
                  ),
                ],
              ),
            );
          },
          tabletBuilder: (context, constraints) {
            return SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterContent(
                    onPressedMenu: () => controller.openDrawer(),
                  ),
                  _buildTaskContent(
                    onPressedMenu: () => controller.openDrawer(),
                  ),
                ],
              ),
            );
          },
          desktopBuilder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 3 : 4,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildSidebar(context),
                  ),
                ),
                Flexible(
                  flex: constraints.maxWidth > 1350 ? 10 : 9,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildTaskContent(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const VerticalDivider(),
                ),
                Flexible(
                  flex: 4,
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: _buildFilterContent(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: UserProfile(
            data: controller.dataProfil,
            onPressed: controller.onPressedProfil,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _MainMenu(onSelected: controller.onSelectedMainMenu),
        ),
        const Divider(
          indent: 20,
          thickness: 1,
          endIndent: 20,
          height: 60,
        ),
        // _Member(member: controller.member),
        const SizedBox(height: kSpacing),
        // _TaskMenu(
        //   onSelected: controller.onSelectedTaskMenu,
        // ),
        const SizedBox(height: kSpacing),
        const Padding(
          padding: EdgeInsets.all(kSpacing),
          child: Text(
            "2024 Arzuman",
          ),
        ),
      ],
    );
  }

  Widget _buildTaskContent({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              if (onPressedMenu != null)
                Padding(
                  padding: const EdgeInsets.only(right: kSpacing / 2),
                  child: IconButton(
                    onPressed: onPressedMenu,
                    icon: const Icon(Icons.menu),
                  ),
                ),
              Expanded(
                child: SearchField(
                  onSearch: controller.searchTask,
                  hintText: "Search Task .. ",
                ),
              ),
            ],
          ),
          const SizedBox(height: kSpacing),
          Row(
            children: [
              Expanded(
                child: HeaderText(
                  DateTime.now().formatdMMMMY(),
                ),
              ),
              const SizedBox(width: kSpacing / 2),
              // SizedBox(
              //   width: 200,
              //   child: TaskProgress(data: controller.dataTask),
              // ),
            ],
          ),
          const SizedBox(height: kSpacing),
          const AllApartmentsScreen(),

          // const SizedBox(height: kSpacing * 2),
          // const _HeaderWeeklyTask(),
          // const SizedBox(height: kSpacing),
          // _WeeklyTask(
          //   data: controller.weeklyTask,
          //   onPressed: controller.onPressedTask,
          //   onPressedAssign: controller.onPressedAssignTask,
          //   onPressedMember: controller.onPressedMemberTask,
          // )
        ],
      ),
    );
  }

  Widget _buildFilterContent({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        children: [
          const SizedBox(height: kSpacing),
          Row(
            children: [
              const Expanded(child: HeaderText("Filter")),
              IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.funnelOutline),
                tooltip: "Filter",
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const FilterOfAppartments(),
          // const SizedBox(height: kSpacing),
          // ...controller.taskGroup
          //     .map(
          //       (e) => _TaskGroup(
          //         title: DateFormat('d MMMM').format(e[0].date),
          //         data: e,
          //         onPressed: controller.onPressedTaskGroup,
          //       ),
          //     )
          //     .toList()
        ],
      ),
    );
  }
}
