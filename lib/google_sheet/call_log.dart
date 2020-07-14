class VideoCallLog {
  String userType;
  String Name;
  String time;
  String event;


  VideoCallLog(this.Name, this.time,  this.event ,this.userType);

  // Method to make GET parameters.
  String toParams() =>
      "?Name=$Name&time=$time&event=$event&userType=$userType";


}