import 'package:flutter/material.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';

class UnlockRequest extends StatefulWidget {
  final String docID;
  final String uid;
  final String reason;
  final bool unlock;

  const UnlockRequest(
      {required this.docID,
      required this.uid,
      required this.reason,
      required this.unlock,
      Key? key})
      : super(key: key);

  @override
  _UnlockRequestState createState() => _UnlockRequestState();
}

class _UnlockRequestState extends State<UnlockRequest> {
  late bool isUnlocked;

  @override
  void initState() {
    super.initState();
    isUnlocked = widget.unlock;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'uid: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: widget.uid),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Reason: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: widget.reason),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Checkbox(
            value: isUnlocked,
            onChanged: (val) async {
              if (isUnlocked == false) {
                await DatabaseService(uid: AuthService().getUser()!.uid)
                    .unlockUser(widget.docID);
                setState(() => isUnlocked = true);
              }
            },
          ),
        ],
      ),
    );
  }
}
