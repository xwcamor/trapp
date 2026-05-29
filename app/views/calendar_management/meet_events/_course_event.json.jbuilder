 
json.id "course_event_#{course_event.id}"
json.title course_event.title
json.start course_event.start
json.end course_event.end

json.color course_event.color unless course_event.color.blank?


json.update_url course_event_path(course_event, method: :patch)
json.edit_url edit_course_event_path(course_event)
