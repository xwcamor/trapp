class ReportManagement::ReportsController < ApplicationController
  before_action :authenticate_user 
  before_action :set_model, only: [:show, :edit, :update, :destroy]
  layout "report", only: [:show]

  # IA MODELS
  #MODEL_IA = "gpt-4o"#mas caro
  MODEL_IA = "gpt-3.5-turbo2" #estable y comodo
  MODEL_IA_OPENROUTER = "mistralai/mistral-7b-instruct"

  # GET /mark_management/reports
  # GET /mark_management/reports.json 
  def upload_customer_file
    if user_permission.include?(158)
      @report = Report.find(params[:report_id])
    
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /mark_management/reports
  # GET /mark_management/reports.json 
  def index
    if user_permission.include?(141)
      @reports = Report.where("deleted= 0 AND user_id  = ?",current_user.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end
  end

  # GET /mark_management/reports/new
  def new
    if user_permission.include?(142)
      @report = Report.new
      #2.times do
      #  @nested_contact = @report.report_details.build
      #end
      @list_user_customers = UserCustomer.joins(:customer).where('user_customers.user_id=?',current_user.id).order("customers.country_id DESC, customers.name")
      #@customer_substations = CustomerSubstation.where("deleted=0 AND customer_id IN (?)",@user_customers.map { |e| e.customer_id })
      #@condicion = UserCustomer.where('user_id=?',current_user).length 
      #@list_transformers = Transformer.includes(:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end

  # GET /mark_management/reports/1
  # GET /mark_management/reports/1.json
  def show
    
    if user_permission.include?(143)
      #@report.create_sheets

       @report = Report.find(params[:id])
       @transformers = Transformer.joins(:report_details)
                      .where(report_details: { report_id: @report.id }, deleted: 0)
                      .includes(:chromatographicals, :physicals)

       @total_transformers = @transformers.size
       @transformer_graphs = TransformerGraph.all
          
      respond_to do |format|
        format.html
        format.xls
        format.doc  

        
        format.docx do
          render docx: 'my_view' 
          # Alternatively, if you don't want to create the .docx.erb template you could
         # render docx: 'my_file.docx', content: '<html><head></head><body><p>Hello</p></body></html>'
        end

        format.pdf do
          render pdf: "Reporte_Multiple_#{Time.now.strftime('%Y%m%d_%H%M')}",
                 layout: "pdf",
                 template: "report_management/reports/show",
                 show_as_html: params.key?("debug"),
                 cover: render_to_string(
                   template: "report_management/reports/pdf_cover",  # NUEVA vista solo para la portada
                   layout: "pdf"
                 ),                 
                 # toc: {
                 #    header_text: "Tabla de Contenidos",  # Esta línea crea un encabezado estático
                 #    disable_dotted_lines: false,
                 #    no_toc_header: false,                # Aquí sí puede ir false si lo quieres generar aquí
                 #    level_indentation: 2,
                 #    text_size_shrink: 0.8
                 #  },
                 margin: { top: 10, bottom: 20 },
                 footer: {
                   html: {
                     template: 'layouts/pdf_footer'
                   }
                 },
                 orientation: 'Portrait',
                 page_size: 'A4'
        end



      end          
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end      
  end
  
  def export_combined_pdf
    @report = Report.find(params[:id])
    @transformers = Transformer.joins(:report_details)
                               .where(report_details: { report_id: @report.id }, deleted: 0)
                               .includes(:chromatographicals, :physicals)
    @total_transformers = @transformers.size
    @transformer_graphs = TransformerGraph.all

    # 1. Generar PDFs sin numeración
    paths = {
      cover:    Rails.root.join("tmp", "cover_#{@report.id}.pdf"),
      base:     Rails.root.join("tmp", "base_#{@report.id}.pdf"),
      rec_con:  Rails.root.join("tmp", "rec_con_#{@report.id}.pdf"),
      rec_only: Rails.root.join("tmp", "rec_only_#{@report.id}.pdf"),
      toc:      Rails.root.join("tmp", "toc_#{@report.id}.pdf")
    }

    # Generar portada
    File.binwrite(paths[:cover], WickedPdf.new.pdf_from_string(
      render_to_string(template: "report_management/reports/pdf_cover", layout: "pdf_clean"),
      margin: { top: 10, bottom: 20 }, orientation: 'Portrait', page_size: 'A4'
    ))

    # Generar base
    File.binwrite(paths[:base], WickedPdf.new.pdf_from_string(
      render_to_string(template: "report_management/reports/pdf_base", layout: "pdf_clean"),
      margin: { top: 10, bottom: 20 }, orientation: 'Portrait', page_size: 'A4'
    ))

    # Generar recomendaciones y conclusiones
    [:rec_con, :rec_only].each do |key|
      tpl = key == :rec_con ? "pdf_recommendations_and_conclusions" : "pdf_recommendations"
      html = render_to_string(
        template: "report_management/reports/#{tpl}",
        layout: "pdf_clean",
        formats: [:html],
        locals: { report: @report, transformers: @transformers }
      )
      File.binwrite(paths[key], WickedPdf.new.pdf_from_string(html,
        margin: { top: 10, bottom: 20 }, orientation: 'Portrait', page_size: 'A4'
      ))
    end

    # Generar transformadores
    individual_paths = []
    individual_pages = []
    @transformers.each_with_index do |transformer, index|
      html = render_to_string(
        partial: "report_management/reports/partials/pdf_transformer_block",
        locals: { transformer: transformer, index: index }
      )
      path = Rails.root.join("tmp", "transformer_#{transformer.id}.pdf")
      File.binwrite(path, WickedPdf.new.pdf_from_string(html,
        margin: { top: 10, bottom: 20 }, orientation: 'Portrait', page_size: 'A4'
      ))
      individual_paths << path
      individual_pages << CombinePDF.load(path).pages.count
    end

    # 2. Calcular páginas para TOC
    cover_pages    = CombinePDF.load(paths[:cover]).pages.count
    base_pages     = CombinePDF.load(paths[:base]).pages.count
    rec_con_pages  = CombinePDF.load(paths[:rec_con]).pages.count
    rec_only_pages = CombinePDF.load(paths[:rec_only]).pages.count

    toc_pages = 2 # Begin toc
    alcance_page = cover_pages + toc_pages
    responsable_page = alcance_page + 1
    base_pages = CombinePDF.load(paths[:base]).pages.count
    transformer_start_page = alcance_page + base_pages

    @toc_main = [
      { label: "1. Alcance", page: alcance_page },
      { label: "2. Objetivo", page: alcance_page },
      { label: "3. Responsable del Reporte", page: alcance_page },
      { label: "4. Normas y Referencias", page: alcance_page },
      { label: "5. Metodología de Análisis", page: responsable_page },
      { label: "6. Datos Generales del #{ @total_transformers > 1 ? 'transformadores' : 'transformador' }", page: responsable_page }
    ]

    @toc_transformers = []
    page = transformer_start_page
    @transformers.each_with_index do |t, idx|
      @toc_transformers << {
        label: "7.#{idx+1} #{t.num_tag} | Serial: #{t.num_serie} | Marca: #{t.mark.name} | #{t.num_pot} MVA | #{t.num_vol} KV | #{t.age}",
        page: page
      }
      page += individual_pages[idx]
    end

    recomendaciones_page = page
    #conclusiones_page = recomendaciones_page + rec_only_pages
    conclusiones_page = recomendaciones_page + CombinePDF.load(paths[:rec_con]).pages.count - CombinePDF.load(paths[:rec_only]).pages.count
 
    @toc_main << { label: "8. Recomendaciones Técnicas", page: recomendaciones_page }
    @toc_main << { label: "9. Conclusiones", page: conclusiones_page }

    # 3. Total real de páginas
    total_pages = cover_pages + base_pages + rec_con_pages + individual_pages.sum + 1 # +1 del TOC que viene luego

    # 3.1 Preparar contador de páginas para pie de página
    current_page = 1
    footer_per_section = {}

    [:cover,   :base].each do |key|
      # Cargar cantidad de páginas para ese bloque
      pages = CombinePDF.load(paths[key]).pages.count

      # Generar footer con numeración inicial
      footer_html = render_to_string(
        template: 'layouts/pdf_footer_clean',
        layout: false,
        locals: {
          total_pages: total_pages,
          current_page: current_page
        }
      )

      footer_per_section[key] = footer_html
      current_page += pages
    end

    # Guardar current_page antes de transformadores
    transformer_start_page = current_page

    individual_footer_htmls = []
    individual_pages.each_with_index do |pages, idx|
      footer_html = render_to_string(
        template: 'layouts/pdf_footer_clean',
        layout: false,
        locals: {
          total_pages: total_pages,
          current_page: current_page
        }
      )
      individual_footer_htmls << footer_html
      current_page += pages
    end

    # Pie para recomendaciones y conclusiones
    rec_con_footer_html = render_to_string(
      template: 'layouts/pdf_footer_clean',
      layout: false,
      locals: {
        total_pages: total_pages,
        current_page: current_page
      }
    )
 
    # 4. Footer real
    footer_html = render_to_string(
      template: 'layouts/pdf_footer_clean',
      layout: false,
      locals: { total_pages: total_pages }
    )

    # 4.1 Regenerar bloques con pie de página numerado
    [:cover, :base].each do |key|
      template = case key
                 when :cover then "pdf_cover"
                 when :base then "pdf_base"
                 end

      html = render_to_string(
        template: "report_management/reports/#{template}",
        layout: "pdf_clean",
        formats: [:html],
        locals: { report: @report, transformers: @transformers }
      )

      File.binwrite(paths[key], WickedPdf.new.pdf_from_string(
        html,
        margin: { top: 10, bottom: 20 },
        orientation: 'Portrait',
        page_size: 'A4',
        footer: { content: footer_per_section[key] } # ✅ usar footer correcto
      ))
    end

    # para rec_con, por separado:
    html = render_to_string(
      template: "report_management/reports/pdf_recommendations_and_conclusions",
      layout: "pdf_clean",
      formats: [:html],
      locals: { report: @report, transformers: @transformers }
    )
    File.binwrite(paths[:rec_con], WickedPdf.new.pdf_from_string(
      html,
      margin: { top: 10, bottom: 20 },
      orientation: 'Portrait',
      page_size: 'A4',
      footer: { content: rec_con_footer_html } # ✅ usar footer correcto
    ))

    # 4.2 Regenerar cada transformador con footer
    @transformers.each_with_index do |transformer, index|
      html = render_to_string(
        partial: "report_management/reports/partials/pdf_transformer_block",
        locals: { transformer: transformer, index: index }
      )

      path = individual_paths[index]

      File.binwrite(path, WickedPdf.new.pdf_from_string(
        html,
        margin: { top: 10, bottom: 20 },
        orientation: 'Portrait',
        page_size: 'A4',
        footer: { content: individual_footer_htmls[index] } # ✅ correcto por bloque
      ))
    end
 
    # 5. Generar TOC con numeración final
    toc_html = render_to_string(
      template: "report_management/reports/pdf_toc",
      layout:   "pdf_clean",
      formats:  [:html],
      locals:   { toc_main: @toc_main, toc_transformers: @toc_transformers }
    )

    # 5.1 GENERAR EL PDF EN MEMORIA
    pdf_binary = WickedPdf.new.pdf_from_string(
      toc_html,
      margin:      { top: 10, bottom: 20 },
      orientation: 'Portrait',
      page_size:   'A4',
      footer:      { content: footer_html }
    )

    # 5.2 VALIDAR QUE NO VENGA VACÍO
    if pdf_binary.blank?
      raise "WickedPdf falló: no pudo generar el TOC. Revisa el HTML o la capacidad del motor."
    end

    # 5.3 ESCRIBIR EL ARCHIVO SOLO SI TODO ESTÁ OK
    File.binwrite(paths[:toc], pdf_binary)

    # 6. Combinar todo
    final_pdf = CombinePDF.new
    final_pdf << CombinePDF.load(paths[:cover])
    unless File.exist?(paths[:toc])
      raise "TOC file not found! Algo falló antes de generarlo."
    end

    final_pdf << CombinePDF.load(paths[:toc])
    final_pdf << CombinePDF.load(paths[:base])
    individual_paths.each { |p| final_pdf << CombinePDF.load(p) }
    final_pdf << CombinePDF.load(paths[:rec_con])

    # 7. ESTAMPAR "n / total" en cada página
    require 'prawn'
    total_pages = final_pdf.pages.count
    numbered_pdf = CombinePDF.new
    final_pdf.pages.each_with_index do |page, idx|
      prawn_tmp = Prawn::Document.new(page_size: 'A4', margin: [0, 0, 0, 0])
      prawn_tmp.font_size 6
    prawn_tmp.bounding_box([476, 50], width: 80, height: 20) do
      prawn_tmp.text "#{idx + 1} / #{total_pages}", align: :center, valign: :center
    end
      number_layer = CombinePDF.parse(prawn_tmp.render)
      
      page << number_layer.pages[0]   # la superposición correcta
      numbered_pdf << page
    end

    # 8. Enviar el PDF ya numerado
    send_data numbered_pdf.to_pdf,
              filename: "ReporteCompleto_#{Time.now.strftime('%Y%m%d_%H%M')}.pdf",
              type: 'application/pdf',
              disposition: 'inline'
  end

  # Prompt used for IA
  def build_prompt_to_ia(transformer)
    prompt2 = <<~TEXT1
      Transformador: #{@transformer.num_tag}, Serial: #{@transformer.num_serie}
      Marca: #{@transformer.mark.name}, Potencia: #{@transformer.num_pot} MVA, Voltaje: #{@transformer.num_vol} kV

      #{tbl_croma_with_limits(@transformer)}
      #{tbl_fq_with_limits(@transformer)}

      Brinda un análisis técnico en español sobre la evolución de los gases disueltos en aceite y las propiedades físico-químicas del transformador.
      
      Ten en cuenta lo siguiente:
      - Si los valores superan los límites técnicos (IEC o IEEE), menciónalo.
      - Indica si los gases han aumentado o disminuido entre fechas.
      - Comenta si se detecta algún posible fallo eléctrico, térmico o de envejecimiento del papel aislante.
      - En cada gas, indica su tendencia y su importancia.
      - Si todo está en orden, menciónalo claramente también.

      Finaliza con un resumen general y una recomendación.
    TEXT1

    prompt = <<~TEXT 
      You are a transformer diagnostics expert. Based on the following chromatographic and physicochemical data, generate a detailed technical analysis in **Spanish**.

      Output should be formal and clear, suitable for an engineering report. Avoid filler words.

      The report should:
      - Mention if values exceed IEC or IEEE limits.
      - Indicate trends (increase/decrease) of gases between dates.
      - Detect signs of thermal/electrical faults or aging of the insulating paper.
      - Summarize the situation and give a recommendation at the end.

      #{tbl_croma_with_limits(transformer)}
      #{tbl_fq_with_limits(transformer)}      
    TEXT
  end

  # Information for Cromas
  def tbl_croma_with_limits(transformer)
    cromas = transformer.chromatographicals.where(deleted: 0).order(date_rehearsal: :desc).limit(2)
    return "No chromatographic data available." if cromas.empty?

    latest = cromas.first
    previous = cromas.second
    fecha = latest.str_date_rehearsal

    gases = {
      "Hydrogen" => { attr: :num_hid, limit: latest.iec_hidrogeno.to_f },
      "Methane" => { attr: :num_met, limit: latest.iec_metano.to_f },
      "Carbon monoxide (CO)" => { attr: :num_mon, limit: latest.iec_monocarbono.to_f },
      "Carbon dioxide (CO₂)" => { attr: :num_dio, limit: latest.iec_diocarbono.to_f },
      "Ethylene" => { attr: :num_eti, limit: latest.iec_etileno.to_f },
      "Ethane" => { attr: :num_eta, limit: latest.iec_etano.to_f },
      "Acetylene" => { attr: :num_ace, limit: latest.iec_acetileno.to_f }
    }

    out_of_range = []

    gases.each do |name, data|
      val_now = latest.send(data[:attr]).to_f
      val_before = previous&.send(data[:attr]).to_f
      limit = data[:limit]

      next if val_now <= 0 || limit <= 0

      trend = if val_before > 0
        if val_now > val_before
          " (increased from #{val_before})"
        elsif val_now < val_before
          " (decreased from #{val_before})"
        else
          ""
        end
      else
        ""
      end

      if val_now > limit
        out_of_range << "• #{name} = #{val_now} ppm exceeds IEC limit of #{limit} ppm#{trend}."
      end
    end

    if out_of_range.empty?
      "✅ All chromatographic gases are within IEC recommended limits (#{fecha})."
    else
      "⚠️ Chromatographic deviations detected on #{fecha}:\n" + out_of_range.join("\n")
    end
  end



  def tbl_croma_with_limits_es(transformer)
    cromas = transformer.chromatographicals.where(deleted: 0).order(date_rehearsal: :desc).limit(2)

    return "No hay datos cromatográficos disponibles." if cromas.empty?

    # Extraer fechas
    fechas = cromas.map(&:str_date_rehearsal)

    # Extraer límites del registro más reciente
    limites = cromas.first
    limites_hash = {
      "Hidrógeno" => "#{limites.iec_hidrogeno} ppm",
      "Metano" => "#{limites.iec_metano} ppm",
      "Monóxido CO" => "#{limites.iec_monocarbono} ppm",
      "Dióxido CO2" => "#{limites.iec_diocarbono} ppm",
      "Etileno" => "#{limites.iec_etileno} ppm",
      "Etano" => "#{limites.iec_etano} ppm",
      "Acetileno" => "#{limites.iec_acetileno} ppm"
    }

    tabla = "Historial de análisis cromatográficos (gases disueltos en aceite):\n\n"
    tabla << "Gas            | Lím. Máx. (IEC) | #{fechas[0]} | #{fechas[1] || '-'}\n"
    tabla << "-" * 65 + "\n"

    gases = {
      "Hidrógeno" => :num_hid,
      "Metano" => :num_met,
      "Monóxido CO" => :num_mon,
      "Dióxido CO2" => :num_dio,
      "Etileno" => :num_eti,
      "Etano" => :num_eta,
      "Acetileno" => :num_ace
    }

    gases.each do |nombre, atributo|
      val_0 = cromas[0].send(atributo).to_s.presence || "-"
      val_1 = cromas[1]&.send(atributo).to_s.presence || "-"
      tabla << "#{nombre.ljust(14)}| #{limites_hash[nombre].ljust(16)}| #{val_0.ljust(10)}| #{val_1.ljust(10)}\n"
    end

    tabla
  end

  # Information for FQ
  def tbl_fq_with_limits(transformer)
    registros_fq = transformer.physicals.where(deleted: 0).order(date_rehearsal: :desc)
    return "No physicochemical data available." if registros_fq.empty?

    last = registros_fq.first
    fecha = last.str_date_rehearsal
    out_of_range = []

    oil_requires_ift = [1, 5, 6].include?(transformer.oil_type_id)

    # Ácido
    if last.ieee_num_acid.to_f > 0 && last.num_acid.to_f > last.ieee_num_acid.to_f
      out_of_range << "• Acid number (#{last.num_acid}) exceeds IEEE max (#{last.ieee_num_acid})."
    end

    # Potencia 25 °C
    if last.ieee_num_pot.to_f > 0 && last.num_pot.to_f > last.ieee_num_pot.to_f
      out_of_range << "• Power factor at 25°C (#{last.num_pot}) exceeds IEEE max (#{last.ieee_num_pot})."
    end

    # Potencia 100 °C (solo si valor > 0)
    if last.ieee_num_pot2.to_f > 0 && last.num_pot2.to_f > 0 && last.num_pot2.to_f > last.ieee_num_pot2.to_f
      out_of_range << "• Power factor at 100°C (#{last.num_pot2}) exceeds IEEE max (#{last.ieee_num_pot2})."
    end

    # Rigidez 2 mm
    if last.ieee_num_rig.to_f > 0 && last.num_rig.to_f < last.ieee_num_rig.to_f
      out_of_range << "• Breakdown voltage 2mm (#{last.num_rig} kV) is below IEEE min (#{last.ieee_num_rig} kV)."
    end

    # Rigidez 2.5 mm (solo si valor > 0)
    if last.ieee_num_rig2.to_f > 0 && last.num_rig2.to_f > 0 && last.num_rig2.to_f < last.ieee_num_rig2.to_f
      out_of_range << "• Breakdown voltage 2.5mm (#{last.num_rig2} kV) is below IEEE min (#{last.ieee_num_rig2} kV)."
    end

    # Tensión interfacial (solo si tipo de aceite lo requiere y valor > 0)
    if oil_requires_ift && last.ieee_num_ten.to_f > 0 && last.num_ten.to_f > 0 && last.num_ten.to_f < last.ieee_num_ten.to_f
      out_of_range << "• Interfacial tension (#{last.num_ten} mN/m) is below IEEE min (#{last.ieee_num_ten} mN/m)."
    end

    # Contenido de agua
    if last.ieee_num_wat.to_f > 0 && last.num_wat.to_f > last.ieee_num_wat.to_f
      out_of_range << "• Water content (#{last.num_wat} ppm) exceeds IEEE max (#{last.ieee_num_wat} ppm)."
    end

    if out_of_range.empty?
      "All physicochemical parameters are within IEEE C57.106 recommended limits (#{fecha})."
    else
      "Physicochemical deviations detected on #{fecha}:\n" + out_of_range.join("\n")
    end
  end


  def tbl_fq_with_limits_es(transformer)
    registros_fq = transformer.physicals.where(deleted: 0).order(date_rehearsal: :desc)
    return "" if registros_fq.empty?

    first = registros_fq.first

    limites = []
    limites << "Ácido (máx): #{first.ieee_num_acid}" if first.ieee_num_acid.present?
    limites << "Potencia 25°C (máx): #{first.ieee_num_pot}" if first.ieee_num_pot.present?
    limites << "Potencia 100°C (máx): #{first.ieee_num_pot2}" if first.ieee_num_pot2.to_f > 0
    limites << "Rigidez 2mm (mín): #{first.ieee_num_rig}" if first.ieee_num_rig.present?
    limites << "Rigidez 2.5mm (mín): #{first.ieee_num_rig2}" if first.ieee_num_rig2.to_f > 0
    if [1, 5, 6].include?(transformer.oil_type_id)
      limites << "Tensión interfacial (mín): #{first.ieee_num_ten}" if first.ieee_num_ten.present?
    end
    limites << "Contenido de agua (máx): #{first.ieee_num_wat}" if first.ieee_num_wat.present?

    tabla_fq = "\nLímites según IEEE C57.106:\n"
    tabla_fq += limites.join(" | ") + "\n"
    tabla_fq += "Historial de análisis físico-químico (calidad del aceite):\n"
    tabla_fq += "Fecha       | Ácido | Pot_25 | Pot_100 | Rig_2mm | Rig_2_5mm | Ten. | Agua\n"
    tabla_fq += "-" * 72 + "\n"

    registros_fq.each do |r|
      fecha = r.str_date_rehearsal
      aci   = r.num_acid.to_s.presence || "-"
      pot   = r.num_pot.to_s.presence || "-"
      pot2  = r.num_pot2.to_f > 0 ? r.num_pot2.to_s : "-"
      rig   = r.num_rig.to_s.presence || "-"
      rig2  = r.num_rig2.to_f > 0 ? r.num_rig2.to_s : "-"
      ten   = [1,5,6].include?(transformer.oil_type_id) ? (r.num_ten.to_s.presence || "-") : "-"
      wat   = r.num_wat.to_s.presence || "-"

      tabla_fq << "#{fecha.ljust(12)}| #{aci.ljust(5)}| #{pot.ljust(7)}| #{pot2.ljust(8)}| #{rig.ljust(8)}| #{rig2.ljust(10)}| #{ten.ljust(5)}| #{wat}\n"
    end

    tabla_fq
  end


  def generar_comentarios_tecnicos
    update!(
      comment_cro: comentario_cromatografico,
      comment_fiq: comentario_fisicoquimico
    )
  end

  def comentario_cromatografico
    # versión corta en español
    cromas = transformer.chromatographicals.where(deleted: 0).order(date_rehearsal: :desc).limit(2)
    return "No se cuenta con datos cromatográficos." if cromas.empty?

    actual = cromas.first
    anterior = cromas.second
    fecha = actual.str_date_rehearsal

    gases = {
      "Hidrógeno" => { attr: :num_hid, limite: actual.iec_hidrogeno.to_f },
      "Metano" => { attr: :num_met, limite: actual.iec_metano.to_f },
      "Monóxido de carbono (CO)" => { attr: :num_mon, limite: actual.iec_monocarbono.to_f },
      "Dióxido de carbono (CO₂)" => { attr: :num_dio, limite: actual.iec_diocarbono.to_f },
      "Etileno" => { attr: :num_eti, limite: actual.iec_etileno.to_f },
      "Etano" => { attr: :num_eta, limite: actual.iec_etano.to_f },
      "Acetileno" => { attr: :num_ace, limite: actual.iec_acetileno.to_f }
    }

    comentarios = []

    gases.each do |nombre, info|
      val = actual.send(info[:attr]).to_f
      val_ant = anterior&.send(info[:attr]).to_f
      limite = info[:limite]
      next if val <= 0 || limite <= 0

      tendencia = if val_ant > 0
        if val > val_ant
          " (aumentó desde #{val_ant})"
        elsif val < val_ant
          " (disminuyó desde #{val_ant})"
        else
          ""
        end
      else
        ""
      end

      if val > limite
        comentarios << "• El gas #{nombre} presenta un valor elevado de #{val} ppm, superando el límite IEC de #{limite} ppm#{tendencia}."
      end
    end

    if comentarios.empty?
      "✅ Todos los gases disueltos están dentro de los límites establecidos por IEC (#{fecha})."
    else
      "⚠️ Análisis cromatográfico (#{fecha}):\n" + comentarios.join("\n")
    end
  end

  def comentario_fisicoquimico
    fisicos = transformer.physicals.where(deleted: 0).order(date_rehearsal: :desc)
    return "No se cuenta con datos físico-químicos." if fisicos.empty?

    registro = fisicos.first
    fecha = registro.str_date_rehearsal
    comentarios = []

    if registro.ieee_num_acid.to_f > 0 && registro.num_acid.to_f > registro.ieee_num_acid.to_f
      comentarios << "• El valor de acidez (#{registro.num_acid}) supera el límite IEEE (#{registro.ieee_num_acid})."
    end

    if registro.ieee_num_pot.to_f > 0 && registro.num_pot.to_f > registro.ieee_num_pot.to_f
      comentarios << "• El factor de potencia a 25°C (#{registro.num_pot}) supera el límite IEEE (#{registro.ieee_num_pot})."
    end

    if registro.ieee_num_pot2.to_f > 0 && registro.num_pot2.to_f > 0 && registro.num_pot2.to_f > registro.ieee_num_pot2.to_f
      comentarios << "• El factor de potencia a 100°C (#{registro.num_pot2}) supera el límite IEEE (#{registro.ieee_num_pot2})."
    end

    if registro.ieee_num_rig.to_f > 0 && registro.num_rig.to_f < registro.ieee_num_rig.to_f
      comentarios << "• La rigidez dieléctrica a 2 mm (#{registro.num_rig} kV) está por debajo del mínimo IEEE (#{registro.ieee_num_rig} kV)."
    end

    if registro.ieee_num_rig2.to_f > 0 && registro.num_rig2.to_f > 0 && registro.num_rig2.to_f < registro.ieee_num_rig2.to_f
      comentarios << "• La rigidez dieléctrica a 2.5 mm (#{registro.num_rig2} kV) está por debajo del mínimo IEEE (#{registro.ieee_num_rig2} kV)."
    end

    if [1, 5, 6].include?(transformer.oil_type_id) && registro.ieee_num_ten.to_f > 0 && registro.num_ten.to_f > 0 && registro.num_ten.to_f < registro.ieee_num_ten.to_f
      comentarios << "• La tensión interfacial (#{registro.num_ten} mN/m) está por debajo del mínimo IEEE (#{registro.ieee_num_ten} mN/m)."
    end

    if registro.ieee_num_wat.to_f > 0 && registro.num_wat.to_f > registro.ieee_num_wat.to_f
      comentarios << "• El contenido de agua (#{registro.num_wat} ppm) supera el máximo IEEE (#{registro.ieee_num_wat} ppm)."
    end

    if comentarios.empty?
      "✅ Todos los parámetros físico-químicos están dentro de los límites IEEE C57.106 (#{fecha})."
    else
      "⚠️ Análisis físico-químico (#{fecha}):\n" + comentarios.join("\n")
    end
  end





  # GET /mark_management/reports/1/edit
  def edit
    if user_permission.include?(144)
      @report_details = ReportDetail.where("report_id = ?",@report.id)
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end         
  end

  # POST /mark_management/reports
  # POST /mark_management/reports.json
  def create

    @report = Report.new(model_params)
 
    if @report.save
      @customer_substations = CustomerSubstation.where("deleted=0 AND customer_id = ?", @report.customer_id )
      @list_transformers = Transformer.includes(:mark, :customer_substation=> [ :customer_area, :customer_area=> [ :customer_location =>[:customer =>[:country] ] ] ] ).where("deleted=0 AND customer_substation_id IN (?)",@customer_substations.map { |e| e.id })    

      @list_transformers.each do |transformer|
        if params["transformer_"+transformer.id.to_s] == "on"
          report_detail = ReportDetail.new
          report_detail.transformer_id = transformer.id
          report_detail.report_id = @report.id
          report_detail.save
          report_detail.generar_comentarios_tecnicos
        end
      end      
      flash[:notice] = 'Data creada.'
      flash[:type_message] = 'success'
      redirect_to [:report_management,:reports]
    else
      flash[:notice] = 'Error al crear.'
      flash[:type_message] = 'danger'
      render :new
    end 
  end

  # PATCH/PUT /mark_management/reports/1
  # PATCH/PUT /mark_management/reports/1.json
  def update
    if @report.update(model_params)
      flash[:notice] = 'Data actualizada.'
      flash[:type_message] = 'success'
      redirect_to [:report_management, :reports]    
    else
      flash[:notice] = 'Error al actualizar.'
      flash[:type_message] = 'danger'
      redirect_to [:report_management, :reports]    
    end
  end

  # DELETE /mark_management/reports/1
  # DELETE /mark_management/reports/1.json  
  def destroy
    if user_permission.include?(145)
      @report.update_attribute(:deleted,1)
      flash[:notice] = 'Data eliminada'
      flash[:type_message] = 'success'
      redirect_to [:report_management,:reports]
    else
      flash[:notice] = "No tienes acceso."
      flash[:type_message] = 'danger'
      redirect_to [:user_management,:authentications]
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @report = Report.find(params[:id])
    end
 
    require Rails.root.join("lib", "ai_token_utils")

    def openai_comment(prompt_text, model: "gpt-3.5-turbo")
      tokens = AiTokenUtils.contar_tokens(prompt_text, model)
      costo = AiTokenUtils.estimar_costo(prompt_text, model)

      puts ">> Modelo usado: #{model}"
      puts ">> Tokens estimados: #{tokens}"
      puts ">> Costo estimado: $#{costo}"

      api_key = Rails.application.credentials.dig(:openai, :api_key)

      response = HTTP.headers(
        "Authorization" => "Bearer #{api_key}",
        "Content-Type" => "application/json"
      ).post("https://api.openai.com/v1/chat/completions", json: {
        model: model,
        messages: [
          { role: "system", content: "Eres un experto en diagnóstico de transformadores eléctricos." },
          { role: "user", content: prompt_text }
        ]
      })

      body = JSON.parse(response.body.to_s)
      body.dig("choices", 0, "message", "content")
    rescue => e
      puts ">>> ERROR IA: #{e.message}"
      nil
    end
    
    # Simulate api cost for tests
    def simular_costo_sin_llamar(prompt_text, model: "gpt-4o")
      tokens = AiTokenUtils.contar_tokens(prompt_text, model)
      costo = AiTokenUtils.estimar_costo(prompt_text, model)

      puts "🔍 SIMULACIÓN DE IA (sin llamar al API)"
      puts "Modelo: #{model}"
      puts "Tokens estimados: #{tokens}"
      puts "Costo estimado: $#{costo}"
    end
    
    # Prevent use IA credits
    def should_regenerate_ia?(transformer, report_detail)
      latest_croma = transformer.chromatographicals.where(deleted: 0).maximum(:updated_at)
      latest_fq    = transformer.physicals.where(deleted: 0).maximum(:updated_at)
      last_update  = [latest_croma, latest_fq].compact.max

      return true if report_detail.ia_generated_at.nil?
      return last_update && last_update > report_detail.ia_generated_at
    end

    def generate_footers_for_pages(start_page, total_pages, count)
      (0...count).map do |i|
        render_to_string(
          template: 'layouts/pdf_footer_clean',
          layout: false,
          locals: {
            total_pages: total_pages,
            current_page: start_page + i
          }
        )
      end
    end


 
    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
       params.require(:report).permit!
    end
end
