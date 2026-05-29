json.array! @list_supervisors do |supervisor|
  json.id                         supervisor.id
  json.country_name               supervisor.country_name
  json.num_doc                    supervisor.num_doc
  json.name                       supervisor.name  
  json.lastname                   supervisor.lastname
  #json.created_at                 supervisor.created_at
  #json.updated_at                 supervisor.updated_at
 
  #json.buttons_on  '<a href="' + supervisor_path(supervisor) + '" class="btn btn-success text-white" type="button" title="Ver" ><i class="fa fa-eye"></i> </a> '
  #json.buttons_off ''
 

end  