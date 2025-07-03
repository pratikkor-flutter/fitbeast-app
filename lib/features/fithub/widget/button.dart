import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitbeast/features/fithub/controller/fithub_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainerConnectButton extends StatefulWidget {
  final String trainerId;

  const TrainerConnectButton({required this.trainerId, super.key});

  @override
  State<TrainerConnectButton> createState() => _TrainerConnectButtonState();
}

class _TrainerConnectButtonState extends State<TrainerConnectButton> {
  String status = 'none';
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;


  void checkConnectionStatus(String currentUserId, String trainerId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('connections')
        .where('trainerId', isEqualTo: trainerId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      status = 'accepted';
    } else {
      status = 'none';
    }

    print("Connection status: $status");
    setState(() {});
  }


@override
void initState(){
  super.initState();
    checkConnectionStatus(currentUserId!, widget.trainerId);
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  
    if (currentUserId == null) {
      return const SizedBox.shrink();
    }

    final requestStream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection('requests')
        .where('trainerId', isEqualTo: widget.trainerId)
        .limit(1)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: requestStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final doc = snapshot.data!.docs.first;
          status = doc['status']; // 'pending'
        }

        String buttonText;
        Color buttonColor;
        VoidCallback? onTap;

        if (status == 'accepted') {
          buttonText = 'Connected';
          buttonColor = Colors.green;
          onTap = null;
        } else if (status == 'pending') {
          buttonText = 'Pending';
          buttonColor = Colors.grey;
          onTap = null;
        } else {
          buttonText = 'Connect';
          buttonColor = theme.colorScheme.primary;
          onTap = () async {
            await Get.find<FithubController>()
                .sendConnectionRequest(widget.trainerId);
          };
        }

        return InkWell(
          onTap: onTap,
          child: Container(
            width: 90,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              buttonText,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
