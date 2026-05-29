json.array!  @meetings  do |meeting|
  json.id meeting.id
  json.title meeting.title
  json.start meeting.start
  json.end meeting.end
  json.color meeting.color unless meeting.color.blank?
  json.edit_url edit_meeting_management_meeting_path(meeting.id)
end