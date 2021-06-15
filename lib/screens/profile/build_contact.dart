part of 'profile_info_page.dart';

// ignore: must_be_immutable
class _BuildParticipantsTile extends StatelessWidget {
  final User _user;
  final bool _isAdmin;
  _BuildParticipantsTile(this._user, this._isAdmin);
  double? width;
  @override
  Widget build(BuildContext context) {
    print(Utils.blockWidth * 3);
    // return Text(_user.userName!);
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      width = Utils.blockHeight * 100;
    } else {
      width = double.infinity;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),

      height: Utils.blockHeight * 7,
      width: width,
      margin: EdgeInsets.only(bottom: 20),
      constraints: BoxConstraints(
        minHeight: 80,
        minWidth: double.infinity,
        maxHeight: 120,
        maxWidth: double.infinity,
      ),
      // color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Utils.blockHeight * 5.5,
            width: Utils.blockHeight * 5.5,
            constraints: BoxConstraints(
              minHeight: 65,
              minWidth: 65,
              maxHeight: 90,
              maxWidth: 90,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                image: CachedNetworkImageProvider(_user.photoUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user.userName!,
                      style: TextStyle(
                        fontSize: Utils.blockWidth * 3 > 20
                            ? 20
                            : Utils.blockWidth * 3 < 17
                                ? 17
                                : Utils.blockWidth * 3,
                      ),
                    ),
                    _isAdmin
                        ? Text("admin",
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.6),
                              fontSize: Utils.blockWidth * 3 > 20
                                  ? 20
                                  : Utils.blockWidth * 3 < 15
                                      ? 15
                                      : Utils.blockWidth * 3,
                            ))
                        : const SizedBox(),
                  ],
                ),
                Text(
                  _user.status!,
                  style: TextStyle(
                    fontSize: Utils.blockWidth * 3 > 20
                        ? 20
                        : Utils.blockWidth * 3 < 15
                            ? 15
                            : Utils.blockWidth * 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
