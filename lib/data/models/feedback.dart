class FeedbackItem {
  int id;
  String comment;
  int? feedbackTypeId;
  int? officeId;
  int? officeLevelId;
  int? workplaceId;
  int? guiltyId;
  int userId;
  String userFullName;
  DateTime date;

  FeedbackItem(
      this.id,
      this.comment,
      this.feedbackTypeId,
      this.officeId,
      this.officeLevelId,
      this.workplaceId,
      this.guiltyId,
      this.userId,
      this.userFullName,
      this.date);

  FeedbackItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        comment = json['comment'],
        feedbackTypeId = json['feedbackTypeId'],
        officeId = json['officeId'],
        officeLevelId = json['officeLevelId'],
        workplaceId = json['workplaceId'],
        guiltyId = json['guiltyId'],
        userId = json['userId'],
        userFullName = json['userFullName'],
        date = DateTime.parse(json['date']);
}
