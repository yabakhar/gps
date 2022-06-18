import 'package:flutter/material.dart';
import '../../core/utils/AppSnackBar.dart';
import '../../core/utils/constants.dart';
import '../../widgets/TextInputField.dart';

class SaisirScreen extends StatefulWidget {
  final onSubmit;
  const SaisirScreen({Key? key, this.onSubmit}) : super(key: key);

  @override
  _SaisirScreenState createState() => _SaisirScreenState();
}

class _SaisirScreenState extends State<SaisirScreen> {
  final _controller = TextEditingController(text: "86917003");
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return _buildBody(context: context);
  }

  _buildBody({context}) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        // width: size.width,
        height: MediaQuery.of(context).size.height * 0.35,
        // height: 250,
        //margin: EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Saisir device serial',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            _buildConfigForm(context),
          ],
        ),
      ),
    );
  }

  _buildConfigForm(context) {
    return Form(
      key: _formKey,
      child: Expanded(
        child: Column(
          children: [
            Theme(
              data: ThemeData(primaryColor: const Color(0xff3678b5)),
              child: TextInputField(
                  fillColor: AppColors.greyLightColor,
                  keyboardType: TextInputType.visiblePassword,
                  vContentPadding: 16,
                  controller: _controller,
                  hContentPadding: 0,
                  prefixIcon: Icons.keyboard),
            ),
            const SizedBox(
              height: 25,
            ),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  _submitButton() {
    return InkWell(
      onTap: _onSubmit,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: AppColors.primaryColor),
        child: const Text(
          'valider',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _onSubmit() async {
    if (_controller.text.isNotEmpty) {
      widget.onSubmit(_controller.text);
    } else {
      AppSnackBar.error('Remote address mst not be empty', context);
    }
  }
}
