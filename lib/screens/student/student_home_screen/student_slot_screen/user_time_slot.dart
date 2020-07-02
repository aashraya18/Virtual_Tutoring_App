class UserTimeSlot {
  UserTimeSlot({
    this.studentBookedSlotList,
    this.mentorNotBookedSlotList,
    this.dateSelected,
    this.advisorEmail,
    this.mentorBookedList,
    this.studentEmail,
  });

  String dateSelected;
  String advisorEmail;
  List<dynamic> mentorNotBookedSlotList;
  List<dynamic> studentBookedSlotList;
  List<dynamic> mentorBookedList;
  String studentEmail;
}
