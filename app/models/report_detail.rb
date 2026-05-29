class ReportDetail < ApplicationRecord
  # Model relationships
  belongs_to :report
  belongs_to :transformer

   
  # Actions using private
  #before_save :save_default_values, :if => :new_record?

  # Validate
  #validates_uniqueness_of :name, conditions: -> { where(deleted: '0') }, :case_sensitive => false,:message => "El registro se encuentra en uso."


  def generar_comentarios_tecnicos
    update!(
      comment_cro: comentario_cromatografico,
      comment_fiq: comentario_fisicoquimico,
      conclusion_basic: conclusion_basica
    )
  end

 
  def auto_recommendation
    if conclusion_basic.to_s.include?("[OK]")
      return "No se requieren acciones correctivas en este momento."
    else
      return "Se recomienda revisión técnica del transformador debido a parámetros fuera de los límites establecidos."
    end
    save!
  end

 

 
  private
    def save_default_values
      self.deleted = 0    
    end 

    def comentario_cromatografico
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
        "[OK] Todos los gases disueltos están dentro de los límites establecidos por IEC (#{fecha})."
      else
        "[Advertencia] Análisis cromatográfico del #{fecha}:\n" + comentarios.join("\n")
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

      if [1, 5, 6].include?(transformer.oil_type_id) &&
         registro.ieee_num_ten.to_f > 0 &&
         registro.num_ten.to_f > 0 &&
         registro.num_ten.to_f < registro.ieee_num_ten.to_f
        comentarios << "• La tensión interfacial (#{registro.num_ten} mN/m) está por debajo del mínimo IEEE (#{registro.ieee_num_ten} mN/m)."
      end

      if registro.ieee_num_wat.to_f > 0 && registro.num_wat.to_f > registro.ieee_num_wat.to_f
        comentarios << "• El contenido de agua (#{registro.num_wat} ppm) supera el máximo IEEE (#{registro.ieee_num_wat} ppm)."
      end

      if comentarios.empty?
        "[OK] Todos los parámetros físico-químicos están dentro de los límites IEEE C57.106 (#{fecha})."
      else
        "[Advertencia] Análisis físico-químico del #{fecha}:\n" + comentarios.join("\n")
      end
    end

    def conclusion_basica
      if comentario_cromatografico.include?("[Advertencia]") || comentario_fisicoquimico.include?("[Advertencia]")
        "[Advertencia] Se detectaron parámetros fuera de los límites establecidos. Se recomienda revisión técnica detallada."
      else
        "[OK] Todos los parámetros están dentro de los límites técnicos establecidos. El transformador se encuentra en condición operativa normal."
      end
    end    
end 