// ignore: file_names
import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class WhatsAppProfile extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String? userImage; // Optional in case no image is provided
  final String userId;  // Changed userTitle to userId

  // Constructor to accept user details
  WhatsAppProfile({
    required this.userName,
    required this.userPhone,
    this.userImage,
    required this.userId, // Removed userTitle from constructor
  });

  @override
  State<WhatsAppProfile> createState() => _WhatsAppProfileState();
}

class _WhatsAppProfileState extends State<WhatsAppProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121B22),
      appBar: AppBar(
        backgroundColor: Color(0xFF1F2C34),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                if (widget.userImage != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: widget.userImage!),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFF3B4A54),
                backgroundImage: widget.userImage != null
                    ? NetworkImage(widget.userImage!) // Use user's image if provided
                    : null,
                child: widget.userImage == null
                    ? Icon(Icons.person, size: 80, color: Colors.white70)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.userName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              widget.userPhone,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(Icons.call, 'Audio', Colors.teal, () {
                 
                  print('Audio button pressed');
                }),
                _buildIconButton(Icons.videocam, 'Video', Colors.teal, () {
                  
                  print('Video button pressed');
                }),
                _buildIconButton(Icons.search, 'Search', Colors.teal, () {
                  print('Search button pressed');
                }),
              ],
            ),
            SizedBox(height: 20),
            _buildListTile(Icons.notifications, 'Notifications'),
            _buildListTile(Icons.photo_library, 'Media visibility'),
            _buildListTile(Icons.lock, 'Encryption',
                subtitle: 'Messages and calls are end-to-end\nencrypted. Tap to verify.'),
            _buildListTile(Icons.timelapse, 'Disappearing messages', subtitle: 'Off'),
            SizedBox(height: 20),
            Text('No groups in common', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 20),
            _buildListTile(Icons.group_add, 'Create group with ${widget.userName}', iconColor: Colors.teal),
            _buildListTile(Icons.block, 'Block ${widget.userName}', textColor: Colors.red, iconColor: Colors.red),
            _buildListTile(Icons.thumb_down, 'Report ${widget.userName}', textColor: Colors.red, iconColor: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: color,
          onPressed: onPressed, // Here is where you pass the function
        ),
        Text(label),
      ],
    );
  }

  Widget _buildListTile(IconData icon, String title,
      {String? subtitle, Color iconColor = Colors.white, Color textColor = Colors.white}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.white70)) : null,
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
    );
  }
}

// class CallPage extends StatelessWidget {
//   const CallPage({Key? key, required this.callID}) : super(key: key);
//   final String callID;

//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//      appID: 1043302631, // Your app ID
//       appSign: '7c2378eded47e9928d0b9ac4bf1fc08b913b830d78031e112f4f84b2891862cf',
//       userID: 'user_id',
//       userName: 'user_name',
//       callID: callID,
//       // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
//       config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
//     );
//   }
// }

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the full screen on tap
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain, // Adjust the image fit as needed
          ),
        ),
      ),
    );
  }
}
