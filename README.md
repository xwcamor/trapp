 
# Léeme

Proyecto de ruby on rails usando el template COLOR ADMIN (responsive)

Información de documentación:

* Reveal secrets on terminal
EDITOR=nano bin/rails credentials:edit

* Todas las vistas html.erb son usadas de TEMPLATE APPLE                                 
   WB0N89JMK/color_admin_v4.5/admin/template/template_apple/

* Se borraron 3 carpetas de css
   WB0N89JMK/color_admin_v4.5/admin/assets/css/facebook
   WB0N89JMK/color_admin_v4.5/admin/assets/css/material
   WB0N89JMK/color_admin_v4.5/admin/assets/css/transparent

* Ruby versión : 2.6.4

* Asset Configuration : 

   Ruta:                  root/color_admin_v4.5
   Configuración de path: app/config/application.rb
   Código:                config.assets.paths << path
  
* Deploy de información de archivo db/seed.rb: 
 - rails db:create
 - rails db:migrate
 - rails db:seed

* Correr modo producción los assets config/environments/production
  config.assets.compile = true

* Idioma del calendario
  WB0N89JMK/color_admin_v4.5/admin/assets/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.js

* Nombre del search de los datatables
  WB0N89JMK/color_admin_v4.5/admin//assets/plugins/datatables.net/js/jquery.dataTables.min.js"

* Nombre del search de los datatables
  WB0N89JMK/color_admin_v4.5/admin//assets/plugins/parsleyjs/dist/parsleyjs.min.js"


* No se usó gema para autenticación.

* Tiempo de inicio 11-09-2019


========================= TIPS =====================
-- Starting Rails Server in Production Mode
  rails server -e production 
OR
  rails s -e production
-- Starting Rails Console in Production Mode
  rails console production
OR
  rails c production
-- Migrate in Production Mode
  rake db:migrate RAILS_ENV=production

-- Cambiar datepicker a español
https://es.stackoverflow.com/questions/138334/datepicker-en-español
var q=a.fn.datepicker.dates={en:{days:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
script src="/assets/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.js"

-- usar datetimepicker a español
  script src="/assets/plugins/moment/moment.js"
  script src="/assets/plugins/moment/locale/es.js">

$(function () {
  $('#datepicker-autoClose').datetimepicker({locale:'es'});
});
 
-- Quitar la Barra de espera que usa el script pace.js y cambiarla a STOP
  script src="/assets/js/vendor.min.js"

startOnPageLoad&&r.start()}).call(this)

-- Idioma de los campos de validacion que usan required script
  script src="/assets/plugins/parsleyjs/dist/parsley.min.js"
 
 This value is required

-- Modificar el espacio del perfil en la barra de sidebar 
  assets/css/apple/app.min.css

.app-sidebar .menu .menu-profile{padding:20px;color:#fff

-- Modificar el espacio del perfil en la barra de sidebar 
  assets/css/apple/app.min.css

.app-sidebar-minify-btn i:before{content:"→"}.app-sidebar-minified:not(.app-without-sidebar) 

-- codigo PLUCK
  <%= f.select :customer_id, @customers.pluck("str_country_customer", :id), {include_hidden: false}, { class: 'multiple-select2',multiple: true ,'data-parsley-required'=>"true" }  %> 

-- Modificar el color de los botones exportar para datatables
  /color_admin_v5.1.3/assets/plugins/datatables.net-buttons-bs5/js/buttons.bootstrap5.min.js:

button:{className:"btn btn-red"},

-- Se cambio en el modelo ieediag deleted = 2 antes era el 1 para que borre todo

<%#=  grouped_collection_select(:transformer, :id,@user_customers.all, :customer_locations, :name, :id, :name,
                {}, class: "default form-control", :'data-remote' => 'true', :'data-url' => url_for( :action => 'update_location'  )  )%>


<iframe src="https://drive.google.com/file/d/1rGdXvhEILZlE5QBiX88b1GoF-pBKFoZQ/preview" width="1024" height="768"></iframe>


DATATABLE IMPORTANTE

http://live.datatables.net/kibokupu/3/edit