json.array! @list_transformers do |transformer|

 json.id          transformer.id
 json.serie       transformer.num_serie
 json.tag         transformer.num_tag
 json.country     transformer.customer_substation.customer_area.customer_location.customer.country.short_name.downcase rescue "-"
 json.customer    transformer.customer_substation.customer_area.customer_location.customer.name.upcase rescue "-"
 json.location    transformer.customer_substation.customer_area.customer_location.name.upcase rescue "-"
 json.area        transformer.customer_substation.customer_area.name.upcase rescue "-"
 json.substation  transformer.customer_substation.name.upcase rescue "-"
 json.voltage     transformer.num_vol
 json.power       transformer.num_pot
 json.age         transformer.str_edad rescue "-"
 json.transformer_type  transformer.transformer_type.name.upcase rescue "-"
 json.conmutation_type  transformer.conmutation_type.name.upcase rescue "-"
 json.connection_type   transformer.connection_type.name  rescue "-"
 json.fases        transformer.str_num_fas  rescue "-"
 json.taps         transformer.num_tap rescue "-"
 json.oil_type     transformer.oil_type.name.upcase rescue "-"
 json.mark         transformer.mark.name.upcase rescue "-"
 json.preservation transformer.transformer_preservation.name.upcase rescue "-"
 json.num_health   transformer.num_health  rescue "0"
 json.state_health transformer.state_health rescue "Muy Malo"
 json.color_health transformer.color_health rescue "red"
 json.status       "<i class='fa fa-circle fa-fw text-" + transformer.color_health + "'></i> " + transformer.state_health
 json.ratio       transformer.str_ratio rescue "0"
 
  #json.buttons_on  '<a href="' + supervisor_path(supervisor) + '" class="btn btn-success text-white" type="button" title="Ver" ><i class="fa fa-eye"></i> </a> '
  #json.buttons_off ''
 

end  