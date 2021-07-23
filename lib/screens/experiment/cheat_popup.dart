import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CheatingPopup extends StatefulWidget {
  const CheatingPopup({Key? key}) : super(key: key);

  @override
  _CheatingPopupState createState() => _CheatingPopupState();
}

class _CheatingPopupState extends State<CheatingPopup> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          // TODO make size of column larger than text size.
          children: [
            const Text(
              'Locked',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'You have changed tabs or the browser lost focus. Please provide a reason and request an unlock from one of the researchers.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (val) {},
                decoration: InputDecoration(
                  hintText: 'Reason',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red[700]!,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.red[700]!,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

/*
* Code to show alert
showDialog(
  context: context,
  barrierColor: Colors.white,
  barrierDismissible: false,
  builder: (context) => const CheatingPopup()
);
*/