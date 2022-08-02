// AppBar buildAppBar(BuildContext context) {
//   return AppBar(
//     actions: [
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Image.asset(
//           ConstanceData.primaryIcon,
//           fit: BoxFit.fill,
//           // color: Colors.white,
//           height: 20,
//           // width: 40,
//         ),
//       ),
//       const Spacer(
//         flex: 1,
//       ),
//       Container(
//         decoration: const BoxDecoration(
//             color: ConstanceData.cardColor,
//             borderRadius: BorderRadius.all(Radius.circular(5))),
//         margin: EdgeInsets.symmetric(vertical: 5),
//         padding: EdgeInsets.symmetric(horizontal: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Register as',
//               style: Theme.of(context).textTheme.headline6,
//             ),
//             Text(
//               'WRITER',
//               style: Theme.of(context).textTheme.headline5,
//             ),
//           ],
//         ),
//       ),
//       const Spacer(
//         flex: 6,
//       ),
//       IconButton(
//         onPressed: () {
//           showSearch(
//             context: context,
//             delegate: SearchPage<Book>(
//               items: ConstanceData.Motivational,
//               searchLabel: 'Search e-books and books',
//               suggestion: const Center(
//                 child:
//                 Text('Filter e-books and books by name, author or genre'),
//               ),
//               failure: const Center(
//                 child: Text('No material found :('),
//               ),
//               filter: (current) => [
//                 current.name,
//                 current.author,
//                 // person.age.toString(),
//               ],
//               builder: (book) => ListTile(
//                 title: Text(
//                   book.name ?? '',
//                   style: Theme.of(context).textTheme.headline5,
//                 ),
//                 subtitle: Text(
//                   book.author ?? '',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//                 trailing: CachedNetworkImage(
//                   imageUrl: book.image ?? '',
//                   height: 40,
//                   width: 40,
//                   fit: BoxFit.fill,
//                 ),
//               ),
//             ),
//           );
//         },
//         icon: const Icon(
//           ConstanceData.searchIcon,
//           color: Colors.white,
//           size: 20,
//         ),
//       ),
//       const Spacer(
//         flex: 1,
//       ),
//       GestureDetector(
//         onTap: () {
//           Navigation.instance.navigate('/accountDetails');
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Badge(
//             position: BadgePosition.bottomEnd(),
//             badgeColor: Colors.white,
//             badgeContent: const Icon(
//               ConstanceData.moreIcon,
//               color: Colors.black,
//               size: 10,
//             ),
//             child: const CircleAvatar(
//               // radius: 25, // Image radius
//               backgroundImage: AssetImage(
//                 ConstanceData.humanImage,
//               ),
//             ),
//           ),
//         ),
//       )
//     ],
//   );
// }