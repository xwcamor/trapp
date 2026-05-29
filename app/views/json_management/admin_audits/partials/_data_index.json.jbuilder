json.array! @list_audits do |audit|
 json.id                         audit.id
 json.str_created_at             audit.str_created_at
 json.username                   audit.user.str_complete_name
 json.str_action                 audit.str_action
 json.str_auditable_type         audit.str_auditable_type
 json.str_auditable_type_details simple_format(audit.str_auditable_type_details)
 json.audited_changes            audit.audited_changes.to_s
 
  #json.buttons_on  '<a href="' + supervisor_path(supervisor) + '" class="btn btn-success text-white" type="button" title="Ver" ><i class="fa fa-eye"></i> </a> '
  #json.buttons_off ''

  
end  