class UnlockRequestData {
  final String? docID;
  final String uid;
  final String? reason;
  final bool? unlock;

  const UnlockRequestData(
      {this.docID, required this.uid, this.reason, this.unlock});
}
