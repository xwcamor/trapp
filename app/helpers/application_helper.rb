module ApplicationHelper
	###########################
  include ActionView::Helpers::NumberHelper


def page_entries_info(collection, options = {})
  entry_name = options[:entry_name] || (collection.empty?? 'item' :
      collection.first.class.name.split('::').last.titleize)
  if collection.total_pages < 2
    case collection.size
    when 0; "No hay registros"
    else;     %{(Total:   %d )} % [ collection.total_entries  ]
    end
  else
    %{(Total:   %d )} % [
      collection.total_entries
    ]
  end
end
#########################################

 def active_class(link_path)
  current_page?(link_path) ? "active" : ""
 end

#########################################

  def title(page_title)
    content_for :title, page_title.to_s
  end

#########################################

  def links(link_title)
    content_for :links, '<li class="breadcrumb-item">'.html_safe+link_title.to_s+'</li>'.html_safe
  end

#########################################

  def javascript(*files) #Jalar JS al HEAD
    content_for(:head) {javascript_include_tag(*files)}
  end

############################################

  def stylesheet(*files) #Jalar CSS al HEAD
    content_for(:head) {stylesheet_link_tag(*files)}
  end

############################################

  def calendar_date_select_style(*files) #JALAR Calendar
    content_for(:head) {calendar_date_select_includes(*files)}
  end

##########################################

  def jquery_validationengine(form_id) #Ejecutar el Validador, recibe el ID del Form a Validar
    concat("\n<script type='text/javascript'>\n".html_safe)
    concat("\t$jq = jQuery.noConflict();\n".html_safe)
    concat("\t$jq(document).ready(function() {\n".html_safe)
    concat("\t$jq('##{form_id}').validationEngine();\n".html_safe)
    concat("\t})\n".html_safe)
    concat("</script>".html_safe)
  end

#############################################

  def translation_calendar #Traduccion del calendario a espanhol
    concat("\n<script type='text/javascript'>\n")
    concat("\t_translations = {\n")
    concat("\t\t"+'"OK": "OK",'+"\n")
    concat("\t\t"+'"Now": "Ahora",'+"\n")
    concat("\t\t"+'"Today": "Hoy",'+"\n")
    concat("\t\t"+'"Clear": "Limpiar"'+"\n")
    concat("\t}\n")
    concat("\t"+'Date.weekdays = $w("D L Ma Mi J V S");'+"\n")
    concat("\t"+'Date.months = $w("Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Deciembre" );'+"\n")
    concat("</script>")
  end

#############################################

  def flash_messages
    if !flash[:notice].blank?
      concat('<div class="system_messages">'.html_safe)
      concat("\t".html_safe+'<li class="alert alert-'.html_safe+flash[:type_message].to_s.html_safe+'">'.html_safe)
      concat("\t\t".html_safe+'<span class="ico"></span>'.html_safe)
      concat("\t\t".html_safe+'<strong class="system_title">'.html_safe+flash[:notice].to_s+'</strong>'.html_safe)
      concat("\t".html_safe+'</li>'.html_safe)
      concat("\t".html_safe+'<ul>'.html_safe)
      concat("</div>".html_safe)
      concat("<br/>".html_safe)
      flash[:notice] = nil
    end        
  end


########################################

  def mail(str_mail)
    return '<a href="mailto:'.html_safe+str_mail+'">'.html_safe+str_mail+'</a>'.html_safe
  end



 

#######################################	
end
