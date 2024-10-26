// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:gyanbuddy/utils/assets_path.dart';
import 'package:gyanbuddy/utils/route/route_constant.dart';

// Assuming CustomButton and auth are available in your project
import 'package:gyanbuddy/widgets/button.dart';
import 'package:gyanbuddy/auth//auth_service.dart'; // Update as per your auth import
import 'package:gyanbuddy/pages/user_profile.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).canvasColor,
            child: Column(
              children: [
                StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    return DrawerHeader(
                      padding: const EdgeInsets.all(0),
                      decoration:
                          BoxDecoration(color: Theme.of(context).canvasColor),
                      child: UserAccountsDrawerHeader(
                        margin: const EdgeInsets.all(0),
                        decoration:
                            BoxDecoration(color: Theme.of(context).canvasColor),
                        accountName: Text(
                          user?.displayName ?? "Learning App for kids",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        accountEmail: Text(
                          user?.email ?? "Made with Love",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: user?.photoURL != null
                              ? NetworkImage(user!.photoURL!)
                              : const AssetImage("assets/images/dp.png")
                                  as ImageProvider,
                        ),
                      ),
                    );
                  },
                ),
                // Adding logout button inside the drawer body
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: CustomButton(
                    label: "Sign Out",
                    onPressed: () async {
                      await auth.signout();
                      Navigator.pushReplacementNamed(
                          context, AllRoutesConstant.loginRoute);
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    icon: Icons.exit_to_app,
                    width: double.infinity,
                  ),
                ),
                const Divider(), // Optional: Divider for better separation
                // Menu items
                _buildListTile(
                  icon: Icons.home,
                  title: "Home",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.homeRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.text_fields,
                  title: "A - Z",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.atozRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.pest_control_rodent_outlined,
                  title: "Animals",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.animalRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.egg,
                  title: "Birds",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.birdsRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.cloud,
                  title: "Seasons",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.seasonRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.pentagon_outlined,
                  title: "Shapes",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.shapesRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.back_hand_rounded,
                  title: "Body parts",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.partsRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.work,
                  title: "Occupations",
                  onTap: () {
                    Navigator.pushNamed(
                        context, AllRoutesConstant.occupationRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.sunny,
                  title: "Solar System",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.solarRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.palette,
                  title: "Colours",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.colourRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.local_florist,
                  title: "Flowers",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.flowerRoute);
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.question_mark_outlined,
                  title: "About us",
                  onTap: () {
                    Navigator.pushNamed(context, AllRoutesConstant.aboutRoute);
                  },
                  context: context,
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('User Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: onTap,
    );
  }
}
