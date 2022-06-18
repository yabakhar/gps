import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/utils/Scaneer.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/getPermission.dart';
import '../saisir/SaisirScreen.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  final connectedUser;
  const HomeScreen({Key? key, this.connectedUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var ticket;
  bool isLaoding = false;
  double distance = 500.0;
  @override
  void initState() {
    GetPermission().getpermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppbar(
            context: context,
            title: 'Gps checker',
          ),
          backgroundColor: AppColors.greyLightColor,
          body: isLaoding
              ? _progressLoading()
              : Builder(builder: (context) => _buidBody(context: context))),
    );
  }

  _progressLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }

  _buildAppbar({context, title}) {
    return AppBar(
      actions: const [],
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '$title',
        style: const TextStyle(
          fontFamily: 'Billabong',
          fontSize: 38,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  _buidBody({context}) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Image.asset(
                'assets/images/hardiot_home.png',
                width: size.width * 0.8,
                height: size.width * 0.8,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Flexible(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 8,
                    child: TextFormField(
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (String value) {
                        distance = double.parse(value);
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]+')),
                        LengthLimitingTextInputFormatter(15),
                      ],
                      decoration: const InputDecoration(labelText: 'Distance'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _scanButton(context: context),
                  const SizedBox(
                    height: 20,
                  ),
                  _saisirButton(context: context)
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  _scanButton({context}) {
    return InkWell(
      onTap: () async {
        GetPermission().getpermission();
        String? qrscan = await scanQR();
        if (0 == distance) {
          setState(() {
            distance = 500.0;
          });
        }
        if (qrscan != null) toCheckScreen(qrscan);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(180),
            color: AppColors.primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.qr_code_2,
              color: Colors.white,
              size: 35,
            ),
            Text(
              'scan qrcode',
              style: TextStyle(color: Colors.white, fontSize: 21),
            )
          ],
        ),
      ),
    );
  }

  _saisirButton({context}) {
    return InkWell(
      onTap: () async {
        _saisirModalBottomSheet();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(180),
            color: AppColors.maronDarkColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.edit,
              color: Colors.white,
              size: 35,
            ),
            Text(
              'saisir',
              style: TextStyle(color: Colors.white, fontSize: 21),
            )
          ],
        ),
      ),
    );
  }

  _saisirModalBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SaisirScreen(
            onSubmit: (serial) {
              if (0 == distance) {
                setState(() {
                  distance = 500.0;
                });
              }
              Navigator.pop(context);
              toCheckScreen(serial);
            },
          )),
    );
  }

  toCheckScreen(String? serial) {
    Navigator.pushNamed(context, '/check',
        arguments: {"serial": serial, "distance": distance});
  }
}
