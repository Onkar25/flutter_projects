import 'package:flutter/material.dart';
import 'package:meals/screens/tabs.dart';
import 'package:meals/widgets/main_drawer.dart';

enum Filters { glutenFree, lactosFree, vegeterian, vegan }

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.currentFilter});
  final Map<Filters, bool> currentFilter;
  @override
  State<FiltersScreen> createState() {
    return _FiltersScreensState();
  }
}

class _FiltersScreensState extends State<FiltersScreen> {
  var _glutenFreeFilterSet = false;
  var _lactosFreeFilterSet = false;
  var _vegeterianFilterSet = false;
  var _veganFilterSet = false;

  @override
  void initState() {
    _glutenFreeFilterSet = widget.currentFilter[Filters.glutenFree]!;
    _lactosFreeFilterSet = widget.currentFilter[Filters.lactosFree]!;
    _vegeterianFilterSet = widget.currentFilter[Filters.vegeterian]!;
    _veganFilterSet = widget.currentFilter[Filters.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Filters',
        ),
      ),
      // drawer: MainDrawer(
      //   onSelectScreen: (identifier) {
      //     if (identifier == 'meal') {
      //       Navigator.of(context).pushReplacement(
      //         MaterialPageRoute(
      //           builder: (ctx) => const TabsScreen(),
      //         ),
      //       );
      //     }
      //   },
      // ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool dipPop) {
          if (dipPop) return;
          Navigator.of(context).pop(
            {
              Filters.glutenFree: _glutenFreeFilterSet,
              Filters.lactosFree: _lactosFreeFilterSet,
              Filters.vegeterian: _vegeterianFilterSet,
              Filters.vegan: _veganFilterSet,
            },
          );
        },
        child: Column(
          children: [
            SwitchListTile(
              value: _glutenFreeFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _glutenFreeFilterSet = isChecked;
                });
              },
              title: Text(
                'Gluten free',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              subtitle: Text(
                'Only include gluten free food',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(
                left: 36,
                right: 26,
              ),
            ),
            SwitchListTile(
              value: _lactosFreeFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _lactosFreeFilterSet = isChecked;
                });
              },
              title: Text(
                'loctos free',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              subtitle: Text(
                'Only include loctos free food',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(
                left: 36,
                right: 26,
              ),
            ),
            SwitchListTile(
              value: _vegeterianFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _vegeterianFilterSet = isChecked;
                });
              },
              title: Text(
                'Vegeterian Meal',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              subtitle: Text(
                'Only include Vegeterian food',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(
                left: 36,
                right: 26,
              ),
            ),
            SwitchListTile(
              value: _veganFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _veganFilterSet = isChecked;
                });
              },
              title: Text(
                'Vegan Meal',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              subtitle: Text(
                'Only include Vegan food',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              activeColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(
                left: 36,
                right: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
