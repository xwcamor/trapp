class IeeeDiagDetail < ApplicationRecord
  # Model relationships
  belongs_to :chromatographical
  belongs_to :ieee_diag
 
  def fila1
    IeeeDiagDetail.where('ieee_diag_id = ?',self.ieee_diag_id ).limit(1).offset(0).first
  end

  def fila2
    IeeeDiagDetail.where('ieee_diag_id = ?',self.ieee_diag_id ).limit(1).offset(1).first
  end

  def fila3
    IeeeDiagDetail.where('ieee_diag_id = ?',self.ieee_diag_id ).limit(1).offset(2).first
  end

  def fila4
    IeeeDiagDetail.where('ieee_diag_id = ?',self.ieee_diag_id ).limit(1).offset(3).first
  end

  def fila5
    IeeeDiagDetail.where('ieee_diag_id = ?',self.ieee_diag_id ).limit(1).offset(4).first
  end

  def fila6 
    IeeeDiagDetail.where('ieee_diag_id = ?',self.ieee_diag_id ).limit(1).offset(5).first
  end
  
  def sum_total_hid
    IeeeDiagDetail.joins(:chromatographical).where('ieee_diag_id = ?',self.ieee_diag_id ).sum("chromatographicals.num_hid")
  end  

  def sum_total_met
    IeeeDiagDetail.joins(:chromatographical).where('ieee_diag_id = ?',self.ieee_diag_id ).sum("chromatographicals.num_met")
  end  

  def sum_total_mon
    IeeeDiagDetail.joins(:chromatographical).where('ieee_diag_id = ?',self.ieee_diag_id ).sum("chromatographicals.num_mon")
  end  

  def sum_total_dio
    IeeeDiagDetail.joins(:chromatographical).where('ieee_diag_id = ?',self.ieee_diag_id ).sum("chromatographicals.num_dio")
  end  

  def sum_total_eti
    IeeeDiagDetail.joins(:chromatographical).where('ieee_diag_id = ?',self.ieee_diag_id ).sum("chromatographicals.num_eti")
  end 

  def sum_total_eta
    IeeeDiagDetail.joins(:chromatographical).where('ieee_diag_id = ?',self.ieee_diag_id ).sum("chromatographicals.num_eta")
  end 

  def sum_total_ace
    IeeeDiagDetail.joins(:chromatographical).where('ieee_diag_id = ?',self.ieee_diag_id ).sum("chromatographicals.num_ace")
  end 
 
  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P para 3 muestras     # 
  # # # # # # # # # # # # # # # # # # # 

  def p_fila1_test3
  	fila1 = self.fila1
  	fila3 = self.fila3
    date_fila1 = fila1.chromatographical.date_rehearsal.to_date
    date_fila3 = fila3.chromatographical.date_rehearsal.to_date

    days_fila1 = (date_fila1 - date_fila3).to_i
    return  days_fila1
  end

  def p_fila2_test3
  	fila2 = self.fila2
  	fila3 = self.fila3
    date_fila2 = fila2.chromatographical.date_rehearsal.to_date
    date_fila3 = fila3.chromatographical.date_rehearsal.to_date

    days_fila2 = (date_fila2 - date_fila3).to_i
    return  days_fila2
  end  

  def p_fila3_test3
   return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P2 para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p2_fila1_test3
  	p2_fila1 = self.p_fila1_test3 * self.p_fila1_test3
  	return p2_fila1
  end

  def p2_fila2_test3
  	p2_fila2 = self.p_fila2_test3 * self.p_fila2_test3
  	return p2_fila2
  end

  def p2_fila3_test3
   return 0
  end
 
  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * H2 para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_hid_fila1_test3
  	f1 = self.fila1
    pgas = f1.chromatographical.num_hid * self.p_fila1_test3
  	return pgas
  end

  def p_hid_fila2_test3
  	f2 = self.fila2  	
    pgas = f2.chromatographical.num_hid * self.p_fila2_test3
  	return pgas
  end

  def p_hid_fila3_test3
  	return 0
  end
 
  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CH4 (metano) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_met_fila1_test3
   	f1 = self.fila1
    pgas = f1.chromatographical.num_met * self.p_fila1_test3
  	return pgas
  end

  def p_met_fila2_test3
   	f2 = self.fila2  	
    pgas = f2.chromatographical.num_met * self.p_fila2_test3
  	return pgas
  end

  def p_met_fila3_test3
  	return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CO (monocarbono) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_mon_fila1_test3
   	f1 = self.fila1
    pgas = f1.chromatographical.num_mon * self.p_fila1_test3
  	return pgas
  end

  def p_mon_fila2_test3
   	f2 = self.fila2  	
    pgas = f2.chromatographical.num_mon * self.p_fila2_test3
  	return pgas
  end

  def p_mon_fila3_test3
  	return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CO2 (diocarbono) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_dio_fila1_test3
   	f1 = self.fila1
    pgas = f1.chromatographical.num_dio * self.p_fila1_test3
  	return pgas
  end

  def p_dio_fila2_test3
   	f2 = self.fila2  	
    pgas = f2.chromatographical.num_dio * self.p_fila2_test3
  	return pgas
  end

  def p_dio_fila3_test3
  	return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H4 (etileno) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eti_fila1_test3
   	f1 = self.fila1
    pgas = f1.chromatographical.num_eti * self.p_fila1_test3
  	return pgas
  end

  def p_eti_fila2_test3
   	f2 = self.fila2  	
    pgas = f2.chromatographical.num_eti * self.p_fila2_test3
  	return pgas
  end

  def p_eti_fila3_test3
  	return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H6 (etano) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eta_fila1_test3
   	f1 = self.fila1
    pgas = f1.chromatographical.num_eta * self.p_fila1_test3
  	return pgas
  end

  def p_eta_fila2_test3
   	f2 = self.fila2  	
    pgas = f2.chromatographical.num_eta * self.p_fila2_test3
  	return pgas
  end

  def p_eta_fila3_test3
  	return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H2 (acetileno) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_ace_fila1_test3
   	f1 = self.fila1
    pgas = f1.chromatographical.num_ace * self.p_fila1_test3
  	return pgas
  end

  def p_ace_fila2_test3
   	f2 = self.fila2  	
    pgas = f2.chromatographical.num_ace * self.p_fila2_test3
  	return pgas
  end

  def p_ace_fila3_test3
  	return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_sum_filas_test3
    psum = self.p_fila1_test3 + self.p_fila2_test3 + self.p_fila3_test3
  	return psum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P2 para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p2_sum_filas_test3
    p2sum = self.p2_fila1_test3 + self.p2_fila2_test3 + self.p2_fila3_test3
  	return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * H2 (hidrogeno) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_hid_sum_filas_test3
    p2sum = self.p_hid_fila1_test3 + self.p_hid_fila2_test3 + self.p_hid_fila3_test3
  	return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CH4 (metano) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_met_sum_filas_test3
    p2sum = self.p_met_fila1_test3 + self.p_met_fila2_test3 + self.p_met_fila3_test3
  	return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CO (mcarbono) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_mon_sum_filas_test3
    p2sum = self.p_mon_fila1_test3 + self.p_mon_fila2_test3 + self.p_mon_fila3_test3
  	return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CO2 (diocarbono) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_dio_sum_filas_test3
    p2sum = self.p_dio_fila1_test3 + self.p_dio_fila2_test3 + self.p_dio_fila3_test3
  	return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H4 (etileno) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eti_sum_filas_test3
    p2sum = self.p_eti_fila1_test3 + self.p_eti_fila2_test3 + self.p_eti_fila3_test3
  	return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H6 (etano) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eta_sum_filas_test3
    p2sum = self.p_eta_fila1_test3 + self.p_eta_fila2_test3 + self.p_eta_fila3_test3
  	return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H2 (acetileno) para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_ace_sum_filas_test3
    p2sum = self.p_ace_fila1_test3 + self.p_ace_fila2_test3 + self.p_ace_fila3_test3
  	return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def hid_fila1_test3
  	sumgas = self.sum_total_hid
  	return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def met_fila1_test3
  	sumgas = self.sum_total_met
  	return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE moncarbono para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def mon_fila1_test3
  	sumgas = self.sum_total_mon
  	return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def dio_fila1_test3
  	sumgas = self.sum_total_dio
  	return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def eti_fila1_test3
  	sumgas = self.sum_total_eti
  	return sumgas
  end


  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def eta_fila1_test3
  	sumgas = self.sum_total_eta
  	return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def ace_fila1_test3
  	sumgas = self.sum_total_ace
  	return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno por dia para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_hid_fila1_test3
  	# ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
  	numerador = (3*self.p_hid_sum_filas_test3) - (self.p_sum_filas_test3 * self.hid_fila1_test3)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
  	denominador = (3*self.p2_sum_filas_test3) - (self.p_sum_filas_test3 * self.p_sum_filas_test3)
  	calc = (numerador / denominador)
  	return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno por año para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_hid_fila1_test3
  	 self.day_hid_fila1_test3 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano por dia para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_met_fila1_test3
  	# ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
  	numerador = (3*self.p_met_sum_filas_test3) - (self.p_sum_filas_test3 * self.met_fila1_test3)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
  	denominador = (3*self.p2_sum_filas_test3) - (self.p_sum_filas_test3 * self.p_sum_filas_test3)
  	calc = (numerador / denominador)
  	return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano por año para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_met_fila1_test3
  	 self.day_met_fila1_test3 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE monocarbono por dia para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_mon_fila1_test3
  	# ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
  	numerador = (3*self.p_mon_sum_filas_test3) - (self.p_sum_filas_test3 * self.mon_fila1_test3)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
  	denominador = (3*self.p2_sum_filas_test3) - (self.p_sum_filas_test3 * self.p_sum_filas_test3)
  	calc = (numerador / denominador)
  	return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE monocarbono por año para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_mon_fila1_test3
  	 self.day_mon_fila1_test3 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono por dia para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_dio_fila1_test3
  	# ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
  	numerador = (3*self.p_dio_sum_filas_test3) - (self.p_sum_filas_test3 * self.dio_fila1_test3)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
  	denominador = (3*self.p2_sum_filas_test3) - (self.p_sum_filas_test3 * self.p_sum_filas_test3)
  	calc = (numerador / denominador)
  	return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono por año para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_dio_fila1_test3
  	 self.day_dio_fila1_test3 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno por dia para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_eti_fila1_test3
  	# ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
  	numerador = (3*self.p_eti_sum_filas_test3) - (self.p_sum_filas_test3 * self.eti_fila1_test3)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
  	denominador = (3*self.p2_sum_filas_test3) - (self.p_sum_filas_test3 * self.p_sum_filas_test3)
  	calc = (numerador / denominador)
  	return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno por año para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_eti_fila1_test3
  	 self.day_eti_fila1_test3 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano por dia para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_eta_fila1_test3
  	# ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
  	numerador = (3*self.p_eta_sum_filas_test3) - (self.p_sum_filas_test3 * self.eta_fila1_test3)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
  	denominador = (3*self.p2_sum_filas_test3) - (self.p_sum_filas_test3 * self.p_sum_filas_test3)
  	calc = (numerador / denominador)
  	return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano por año para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_eta_fila1_test3
  	 self.day_eta_fila1_test3 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno por dia para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_ace_fila1_test3
  	# ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
  	numerador = (3*self.p_ace_sum_filas_test3) - (self.p_sum_filas_test3 * self.ace_fila1_test3)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
  	denominador = (3*self.p2_sum_filas_test3) - (self.p_sum_filas_test3 * self.p_sum_filas_test3)
  	calc = (numerador / denominador)
  	return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno por año para 3 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_ace_fila1_test3
  	 self.day_ace_fila1_test3 * 365
  end

 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  
  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P para 4 muestras     # 
  # # # # # # # # # # # # # # # # # # # 

  def p_fila1_test4
    fila1 = self.fila1
    fila4 = self.fila4
    date_fila1 = fila1.chromatographical.date_rehearsal.to_date
    date_fila4 = fila4.chromatographical.date_rehearsal.to_date

    days_fila1 = (date_fila1 - date_fila4).to_i
    return  days_fila1
  end

  def p_fila2_test4
    fila2 = self.fila2
    fila4 = self.fila4
    date_fila2 = fila2.chromatographical.date_rehearsal.to_date
    date_fila4 = fila4.chromatographical.date_rehearsal.to_date

    days_fila2 = (date_fila2 - date_fila4).to_i
    return  days_fila2
  end  

  def p_fila3_test4
    fila3 = self.fila3
    fila4 = self.fila4
    date_fila3 = fila3.chromatographical.date_rehearsal.to_date
    date_fila4 = fila4.chromatographical.date_rehearsal.to_date

    days_fila3 = (date_fila3 - date_fila4).to_i
    return  days_fila3
  end  

  def p_fila4_test4
   return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P2 para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p2_fila1_test4
    p2_fila1 = self.p_fila1_test4 * self.p_fila1_test4
    return p2_fila1
  end

  def p2_fila2_test4
    p2_fila2 = self.p_fila2_test4 * self.p_fila2_test4
    return p2_fila2
  end

  def p2_fila3_test4
    p2_fila3 = self.p_fila3_test4 * self.p_fila3_test4
    return p2_fila3
  end

  def p2_fila4_test4
   return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * H2 para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_hid_fila1_test4
    f1 = self.fila1
    pgas = f1.chromatographical.num_hid * self.p_fila1_test4
    return pgas
  end

  def p_hid_fila2_test4
    f2 = self.fila2   
    pgas = f2.chromatographical.num_hid * self.p_fila2_test4
    return pgas
  end

  def p_hid_fila3_test4
    f3 = self.fila3   
    pgas = f3.chromatographical.num_hid * self.p_fila3_test4
    return pgas
  end

  def p_hid_fila4_test4
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CH4 (metano) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_met_fila1_test4
    f1 = self.fila1
    pgas = f1.chromatographical.num_met * self.p_fila1_test4
    return pgas
  end

  def p_met_fila2_test4
    f2 = self.fila2   
    pgas = f2.chromatographical.num_met * self.p_fila2_test4
    return pgas
  end

  def p_met_fila3_test4
    f3 = self.fila3   
    pgas = f3.chromatographical.num_met * self.p_fila3_test4
    return pgas
  end

  def p_met_fila4_test4
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CO (monocarbono) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_mon_fila1_test4
    f1 = self.fila1
    pgas = f1.chromatographical.num_mon * self.p_fila1_test4
    return pgas
  end

  def p_mon_fila2_test4
    f2 = self.fila2   
    pgas = f2.chromatographical.num_mon * self.p_fila2_test4
    return pgas
  end

  def p_mon_fila3_test4
    f3 = self.fila3   
    pgas = f3.chromatographical.num_mon * self.p_fila3_test4
    return pgas
  end

  def p_mon_fila4_test4
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CO2 (diocarbono) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_dio_fila1_test4
    f1 = self.fila1
    pgas = f1.chromatographical.num_dio * self.p_fila1_test4
    return pgas
  end

  def p_dio_fila2_test4
    f2 = self.fila2   
    pgas = f2.chromatographical.num_dio * self.p_fila2_test4
    return pgas
  end

  def p_dio_fila3_test4
    f3 = self.fila3   
    pgas = f3.chromatographical.num_dio * self.p_fila3_test4
    return pgas
  end

  def p_dio_fila4_test4
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H4 (etileno) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eti_fila1_test4
    f1 = self.fila1
    pgas = f1.chromatographical.num_eti * self.p_fila1_test4
    return pgas
  end

  def p_eti_fila2_test4
    f2 = self.fila2   
    pgas = f2.chromatographical.num_eti * self.p_fila2_test4
    return pgas
  end

  def p_eti_fila3_test4
    f3 = self.fila3   
    pgas = f3.chromatographical.num_eti * self.p_fila3_test4
    return pgas
  end

  def p_eti_fila4_test4
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H6 (etano) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eta_fila1_test4
    f1 = self.fila1
    pgas = f1.chromatographical.num_eta * self.p_fila1_test4
    return pgas
  end

  def p_eta_fila2_test4
    f2 = self.fila2   
    pgas = f2.chromatographical.num_eta * self.p_fila2_test4
    return pgas
  end
  
  def p_eta_fila3_test4
    f3 = self.fila3   
    pgas = f3.chromatographical.num_eta * self.p_fila3_test4
    return pgas
  end

  def p_eta_fila4_test4
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H2 (acetileno) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_ace_fila1_test4
    f1 = self.fila1
    pgas = f1.chromatographical.num_ace * self.p_fila1_test4
    return pgas
  end

  def p_ace_fila2_test4
    f2 = self.fila2   
    pgas = f2.chromatographical.num_ace * self.p_fila2_test4
    return pgas
  end

  def p_ace_fila3_test4
    f3 = self.fila3   
    pgas = f3.chromatographical.num_ace * self.p_fila3_test4
    return pgas
  end

  def p_ace_fila4_test4
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_sum_filas_test4
    psum = self.p_fila1_test4 + self.p_fila2_test4 + self.p_fila3_test4 + self.p_fila4_test4
    return psum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P2 para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p2_sum_filas_test4
    p2sum = self.p2_fila1_test4 + self.p2_fila2_test4 + self.p2_fila3_test4 + self.p2_fila4_test4
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * H2 (hidrogeno) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_hid_sum_filas_test4
    p2sum = self.p_hid_fila1_test4 + self.p_hid_fila2_test4 + self.p_hid_fila3_test4 + self.p_hid_fila4_test4
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CH4 (metano) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_met_sum_filas_test4
    p2sum = self.p_met_fila1_test4 + self.p_met_fila2_test4 + self.p_met_fila3_test4 + self.p_met_fila4_test4
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CO (mcarbono) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_mon_sum_filas_test4
    p2sum = self.p_mon_fila1_test4 + self.p_mon_fila2_test4 + self.p_mon_fila3_test4 + self.p_mon_fila4_test4
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CO2 (diocarbono) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_dio_sum_filas_test4
    p2sum = self.p_dio_fila1_test4 + self.p_dio_fila2_test4 + self.p_dio_fila3_test4 + self.p_dio_fila4_test4
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H4 (etileno) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eti_sum_filas_test4
    p2sum = self.p_eti_fila1_test4 + self.p_eti_fila2_test4 + self.p_eti_fila3_test4 + self.p_eti_fila4_test4
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H6 (etano) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eta_sum_filas_test4
    p2sum = self.p_eta_fila1_test4 + self.p_eta_fila2_test4 + self.p_eta_fila3_test4 + self.p_eta_fila4_test4
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H2 (acetileno) para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_ace_sum_filas_test4
    p2sum = self.p_ace_fila1_test4 + self.p_ace_fila2_test4 + self.p_ace_fila3_test4 + self.p_ace_fila4_test4
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def hid_fila1_test4
    sumgas = self.sum_total_hid
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def met_fila1_test4
    sumgas = self.sum_total_met
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE moncarbono para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def mon_fila1_test4
    sumgas = self.sum_total_mon
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def dio_fila1_test4
    sumgas = self.sum_total_dio
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def eti_fila1_test4
    sumgas = self.sum_total_eti
    return sumgas
  end


  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def eta_fila1_test4
    sumgas = self.sum_total_eta
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def ace_fila1_test4
    sumgas = self.sum_total_ace
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno por dia para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_hid_fila1_test4
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (4*self.p_hid_sum_filas_test4) - (self.p_sum_filas_test4 * self.hid_fila1_test4)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (4*self.p2_sum_filas_test4) - (self.p_sum_filas_test4 * self.p_sum_filas_test4)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno por año para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_hid_fila1_test4
     self.day_hid_fila1_test4 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano por dia para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_met_fila1_test4
    # ( 4 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (4*self.p_met_sum_filas_test4) - (self.p_sum_filas_test4 * self.met_fila1_test4)
    # ( 4 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (4*self.p2_sum_filas_test4) - (self.p_sum_filas_test4 * self.p_sum_filas_test4)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano por año para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_met_fila1_test4
     self.day_met_fila1_test4 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE monocarbono por dia para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_mon_fila1_test4
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (4*self.p_mon_sum_filas_test4) - (self.p_sum_filas_test4 * self.mon_fila1_test4)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (4*self.p2_sum_filas_test4) - (self.p_sum_filas_test4 * self.p_sum_filas_test4)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE monocarbono por año para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_mon_fila1_test4
     self.day_mon_fila1_test4 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono por dia para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_dio_fila1_test4
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (4*self.p_dio_sum_filas_test4) - (self.p_sum_filas_test4 * self.dio_fila1_test4)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (4*self.p2_sum_filas_test4) - (self.p_sum_filas_test4 * self.p_sum_filas_test4)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono por año para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_dio_fila1_test4
     self.day_dio_fila1_test4 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno por dia para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_eti_fila1_test4
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (4*self.p_eti_sum_filas_test4) - (self.p_sum_filas_test4 * self.eti_fila1_test4)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (4*self.p2_sum_filas_test4) - (self.p_sum_filas_test4 * self.p_sum_filas_test4)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno por año para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_eti_fila1_test4
     self.day_eti_fila1_test4 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano por dia para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_eta_fila1_test4
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (4*self.p_eta_sum_filas_test4) - (self.p_sum_filas_test4 * self.eta_fila1_test4)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (4*self.p2_sum_filas_test4) - (self.p_sum_filas_test4 * self.p_sum_filas_test4)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano por año para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_eta_fila1_test4
     self.day_eta_fila1_test4 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno por dia para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_ace_fila1_test4
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (4*self.p_ace_sum_filas_test4) - (self.p_sum_filas_test4 * self.ace_fila1_test4)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (4*self.p2_sum_filas_test4) - (self.p_sum_filas_test4 * self.p_sum_filas_test4)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno por año para 4 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_ace_fila1_test4
     self.day_ace_fila1_test4 * 365
  end

 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  
  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P para 5 muestras     # 
  # # # # # # # # # # # # # # # # # # # 

  def p_fila1_test5
    fila1 = self.fila1
    fila5 = self.fila5
    date_fila1 = fila1.chromatographical.date_rehearsal.to_date
    date_fila5 = fila5.chromatographical.date_rehearsal.to_date

    days_fila1 = (date_fila1 - date_fila5).to_i
    return  days_fila1
  end

  def p_fila2_test5
    fila2 = self.fila2
    fila5 = self.fila5
    date_fila2 = fila2.chromatographical.date_rehearsal.to_date
    date_fila5 = fila5.chromatographical.date_rehearsal.to_date

    days_fila2 = (date_fila2 - date_fila5).to_i
    return  days_fila2
  end  

  def p_fila3_test5
    fila3 = self.fila3
    fila5 = self.fila5
    date_fila3 = fila3.chromatographical.date_rehearsal.to_date
    date_fila5 = fila5.chromatographical.date_rehearsal.to_date

    days_fila3 = (date_fila3 - date_fila5).to_i
    return  days_fila3
  end  

  def p_fila4_test5
    fila4 = self.fila4
    fila5 = self.fila5
    date_fila4 = fila4.chromatographical.date_rehearsal.to_date
    date_fila5 = fila5.chromatographical.date_rehearsal.to_date

    days_fila4 = (date_fila4 - date_fila5).to_i
    return  days_fila4
  end  

  def p_fila5_test5
   return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P2 para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p2_fila1_test5
    p2_fila1 = self.p_fila1_test5 * self.p_fila1_test5
    return p2_fila1
  end

  def p2_fila2_test5
    p2_fila2 = self.p_fila2_test5 * self.p_fila2_test5
    return p2_fila2
  end

  def p2_fila3_test5
    p2_fila3 = self.p_fila3_test5 * self.p_fila3_test5
    return p2_fila3
  end

  def p2_fila4_test5
    p2_fila4 = self.p_fila4_test5 * self.p_fila4_test5
    return p2_fila4
  end

  def p2_fila5_test5
   return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * H2 para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_hid_fila1_test5
    f1 = self.fila1
    pgas = f1.chromatographical.num_hid * self.p_fila1_test5
    return pgas
  end

  def p_hid_fila2_test5
    f2 = self.fila2   
    pgas = f2.chromatographical.num_hid * self.p_fila2_test5
    return pgas
  end

  def p_hid_fila3_test5
    f3 = self.fila3   
    pgas = f3.chromatographical.num_hid * self.p_fila3_test5
    return pgas
  end

  def p_hid_fila4_test5
    f4 = self.fila4   
    pgas = f4.chromatographical.num_hid * self.p_fila4_test5
    return pgas
  end

  def p_hid_fila5_test5
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CH4 (metano) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_met_fila1_test5
    f1 = self.fila1
    pgas = f1.chromatographical.num_met * self.p_fila1_test5
    return pgas
  end

  def p_met_fila2_test5
    f2 = self.fila2   
    pgas = f2.chromatographical.num_met * self.p_fila2_test5
    return pgas
  end

  def p_met_fila3_test5
    f3 = self.fila3   
    pgas = f3.chromatographical.num_met * self.p_fila3_test5
    return pgas
  end

  def p_met_fila4_test5
    f4 = self.fila4   
    pgas = f4.chromatographical.num_met * self.p_fila4_test5
    return pgas
  end

  def p_met_fila5_test5
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CO (monocarbono) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_mon_fila1_test5
    f1 = self.fila1
    pgas = f1.chromatographical.num_mon * self.p_fila1_test5
    return pgas
  end

  def p_mon_fila2_test5
    f2 = self.fila2   
    pgas = f2.chromatographical.num_mon * self.p_fila2_test5
    return pgas
  end

  def p_mon_fila3_test5
    f3 = self.fila3   
    pgas = f3.chromatographical.num_mon * self.p_fila3_test5
    return pgas
  end

  def p_mon_fila4_test5
    f4 = self.fila4   
    pgas = f4.chromatographical.num_mon * self.p_fila4_test5
    return pgas
  end

  def p_mon_fila5_test5
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CO2 (diocarbono) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_dio_fila1_test5
    f1 = self.fila1
    pgas = f1.chromatographical.num_dio * self.p_fila1_test5
    return pgas
  end

  def p_dio_fila2_test5
    f2 = self.fila2   
    pgas = f2.chromatographical.num_dio * self.p_fila2_test5
    return pgas
  end

  def p_dio_fila3_test5
    f3 = self.fila3   
    pgas = f3.chromatographical.num_dio * self.p_fila3_test5
    return pgas
  end

  def p_dio_fila4_test5
    f4 = self.fila4   
    pgas = f4.chromatographical.num_dio * self.p_fila4_test5
    return pgas
  end
  def p_dio_fila5_test5
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H4 (etileno) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eti_fila1_test5
    f1 = self.fila1
    pgas = f1.chromatographical.num_eti * self.p_fila1_test5
    return pgas
  end

  def p_eti_fila2_test5
    f2 = self.fila2   
    pgas = f2.chromatographical.num_eti * self.p_fila2_test5
    return pgas
  end

  def p_eti_fila3_test5
    f3 = self.fila3   
    pgas = f3.chromatographical.num_eti * self.p_fila3_test5
    return pgas
  end

  def p_eti_fila4_test5
    f4 = self.fila4   
    pgas = f4.chromatographical.num_eti * self.p_fila4_test5
    return pgas
  end

  def p_eti_fila5_test5
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H6 (etano) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eta_fila1_test5
    f1 = self.fila1
    pgas = f1.chromatographical.num_eta * self.p_fila1_test5
    return pgas
  end

  def p_eta_fila2_test5
    f2 = self.fila2   
    pgas = f2.chromatographical.num_eta * self.p_fila2_test5
    return pgas
  end
  
  def p_eta_fila3_test5
    f3 = self.fila3   
    pgas = f3.chromatographical.num_eta * self.p_fila3_test5
    return pgas
  end

  def p_eta_fila4_test5
    f4 = self.fila4   
    pgas = f4.chromatographical.num_eta * self.p_fila4_test5
    return pgas
  end

  def p_eta_fila5_test5
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H2 (acetileno) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_ace_fila1_test5
    f1 = self.fila1
    pgas = f1.chromatographical.num_ace * self.p_fila1_test5
    return pgas
  end

  def p_ace_fila2_test5
    f2 = self.fila2   
    pgas = f2.chromatographical.num_ace * self.p_fila2_test5
    return pgas
  end

  def p_ace_fila3_test5
    f3 = self.fila3   
    pgas = f3.chromatographical.num_ace * self.p_fila3_test5
    return pgas
  end

  def p_ace_fila4_test5
    f4 = self.fila4   
    pgas = f4.chromatographical.num_ace * self.p_fila4_test5
    return pgas
  end

  def p_ace_fila5_test5
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_sum_filas_test5
    psum = self.p_fila1_test5 + self.p_fila2_test5 + self.p_fila3_test5 + self.p_fila4_test5 + self.p_fila5_test5
    return psum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P2 para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p2_sum_filas_test5
    p2sum = self.p2_fila1_test5 + self.p2_fila2_test5 + self.p2_fila3_test5 + self.p2_fila4_test5 + self.p2_fila5_test5
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * H2 (hidrogeno) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_hid_sum_filas_test5
    p2sum = self.p_hid_fila1_test5 + self.p_hid_fila2_test5 + self.p_hid_fila3_test5 + self.p_hid_fila4_test5 + self.p_hid_fila5_test5
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CH4 (metano) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_met_sum_filas_test5
    p2sum = self.p_met_fila1_test5 + self.p_met_fila2_test5 + self.p_met_fila3_test5 + self.p_met_fila4_test5 + self.p_met_fila5_test5
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CO (mcarbono) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_mon_sum_filas_test5
    p2sum = self.p_mon_fila1_test5 + self.p_mon_fila2_test5 + self.p_mon_fila3_test5 + self.p_mon_fila4_test5 + self.p_mon_fila5_test5
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CO2 (diocarbono) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_dio_sum_filas_test5
    p2sum = self.p_dio_fila1_test5 + self.p_dio_fila2_test5 + self.p_dio_fila3_test5 + self.p_dio_fila4_test5 + self.p_dio_fila5_test5
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H4 (etileno) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eti_sum_filas_test5
    p2sum = self.p_eti_fila1_test5 + self.p_eti_fila2_test5 + self.p_eti_fila3_test5 + self.p_eti_fila4_test5 + self.p_eti_fila5_test5
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H6 (etano) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eta_sum_filas_test5
    p2sum = self.p_eta_fila1_test5 + self.p_eta_fila2_test5 + self.p_eta_fila3_test5 + self.p_eta_fila4_test5 + self.p_eta_fila5_test5
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H2 (acetileno) para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_ace_sum_filas_test5
    p2sum = self.p_ace_fila1_test5 + self.p_ace_fila2_test5 + self.p_ace_fila3_test5 + self.p_ace_fila4_test5 + self.p_ace_fila5_test5
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def hid_fila1_test5
    sumgas = self.sum_total_hid
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def met_fila1_test5
    sumgas = self.sum_total_met
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE moncarbono para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def mon_fila1_test5
    sumgas = self.sum_total_mon
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def dio_fila1_test5
    sumgas = self.sum_total_dio
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def eti_fila1_test5
    sumgas = self.sum_total_eti
    return sumgas
  end


  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def eta_fila1_test5
    sumgas = self.sum_total_eta
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def ace_fila1_test5
    sumgas = self.sum_total_ace
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno por dia para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_hid_fila1_test5
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (5*self.p_hid_sum_filas_test5) - (self.p_sum_filas_test5 * self.hid_fila1_test5)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (5*self.p2_sum_filas_test5) - (self.p_sum_filas_test5 * self.p_sum_filas_test5)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno por año para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_hid_fila1_test5
     self.day_hid_fila1_test5 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano por dia para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_met_fila1_test5
    # ( 4 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (5*self.p_met_sum_filas_test5) - (self.p_sum_filas_test5 * self.met_fila1_test5)
    # ( 4 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (5*self.p2_sum_filas_test5) - (self.p_sum_filas_test5 * self.p_sum_filas_test5)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano por año para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_met_fila1_test5
     self.day_met_fila1_test5 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE monocarbono por dia para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_mon_fila1_test5
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (5*self.p_mon_sum_filas_test5) - (self.p_sum_filas_test5 * self.mon_fila1_test5)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (5*self.p2_sum_filas_test5) - (self.p_sum_filas_test5 * self.p_sum_filas_test5)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE monocarbono por año para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_mon_fila1_test5
     self.day_mon_fila1_test5 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono por dia para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_dio_fila1_test5
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (5*self.p_dio_sum_filas_test5) - (self.p_sum_filas_test5 * self.dio_fila1_test5)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (5*self.p2_sum_filas_test5) - (self.p_sum_filas_test5 * self.p_sum_filas_test5)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono por año para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_dio_fila1_test5
     self.day_dio_fila1_test5 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno por dia para 55 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_eti_fila1_test5
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (5*self.p_eti_sum_filas_test5) - (self.p_sum_filas_test5 * self.eti_fila1_test5)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (5*self.p2_sum_filas_test5) - (self.p_sum_filas_test5 * self.p_sum_filas_test5)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno por año para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_eti_fila1_test5
     self.day_eti_fila1_test5 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano por dia para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_eta_fila1_test5
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (5*self.p_eta_sum_filas_test5) - (self.p_sum_filas_test5 * self.eta_fila1_test5)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (5*self.p2_sum_filas_test5) - (self.p_sum_filas_test5 * self.p_sum_filas_test5)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano por año para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_eta_fila1_test5
     self.day_eta_fila1_test5 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno por dia para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_ace_fila1_test5
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (5*self.p_ace_sum_filas_test5) - (self.p_sum_filas_test5 * self.ace_fila1_test5)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (5*self.p2_sum_filas_test5) - (self.p_sum_filas_test5 * self.p_sum_filas_test5)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno por año para 5 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_ace_fila1_test5
     self.day_ace_fila1_test5 * 365
  end

 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
  
  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P para 6 muestras     # 
  # # # # # # # # # # # # # # # # # # # 

  def p_fila1_test6
    fila1 = self.fila1
    fila6 = self.fila6
    date_fila1 = fila1.chromatographical.date_rehearsal.to_date
    date_fila6 = fila6.chromatographical.date_rehearsal.to_date

    days_fila1 = (date_fila1 - date_fila6).to_i
    return  days_fila1
  end

  def p_fila2_test6
    fila2 = self.fila2
    fila6 = self.fila6
    date_fila2 = fila2.chromatographical.date_rehearsal.to_date
    date_fila6 = fila6.chromatographical.date_rehearsal.to_date

    days_fila2 = (date_fila2 - date_fila6).to_i
    return  days_fila2
  end  

  def p_fila3_test6
    fila3 = self.fila3
    fila6 = self.fila6
    date_fila3 = fila3.chromatographical.date_rehearsal.to_date
    date_fila6 = fila6.chromatographical.date_rehearsal.to_date

    days_fila3 = (date_fila3 - date_fila6).to_i
    return  days_fila3
  end  

  def p_fila4_test6
    fila4 = self.fila4
    fila6 = self.fila6
    date_fila4 = fila4.chromatographical.date_rehearsal.to_date
    date_fila6 = fila6.chromatographical.date_rehearsal.to_date

    days_fila4 = (date_fila4 - date_fila6).to_i
    return  days_fila4
  end  

  def p_fila5_test6
    fila5 = self.fila5
    fila6 = self.fila6
    date_fila5 = fila5.chromatographical.date_rehearsal.to_date
    date_fila6 = fila6.chromatographical.date_rehearsal.to_date

    days_fila5 = (date_fila5 - date_fila6).to_i
    return  days_fila5
  end  

  def p_fila6_test6
   return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P2 para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p2_fila1_test6
    p2_fila1 = self.p_fila1_test6 * self.p_fila1_test6
    return p2_fila1
  end

  def p2_fila2_test6
    p2_fila2 = self.p_fila2_test6 * self.p_fila2_test6
    return p2_fila2
  end

  def p2_fila3_test6
    p2_fila3 = self.p_fila3_test6 * self.p_fila3_test6
    return p2_fila3
  end

  def p2_fila4_test6
    p2_fila4 = self.p_fila4_test6 * self.p_fila4_test6
    return p2_fila4
  end

  def p2_fila5_test6
    p2_fila5 = self.p_fila5_test6 * self.p_fila5_test6
    return p2_fila5
  end

  def p2_fila6_test6
   return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * H2 para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_hid_fila1_test6
    f1 = self.fila1
    pgas = f1.chromatographical.num_hid * self.p_fila1_test6
    return pgas
  end

  def p_hid_fila2_test6
    f2 = self.fila2   
    pgas = f2.chromatographical.num_hid * self.p_fila2_test6
    return pgas
  end

  def p_hid_fila3_test6
    f3 = self.fila3   
    pgas = f3.chromatographical.num_hid * self.p_fila3_test6
    return pgas
  end

  def p_hid_fila4_test6
    f4 = self.fila4   
    pgas = f4.chromatographical.num_hid * self.p_fila4_test6
    return pgas
  end

  def p_hid_fila5_test6
    f5 = self.fila5   
    pgas = f5.chromatographical.num_hid * self.p_fila5_test6
    return pgas
  end

  def p_hid_fila6_test6
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CH4 (metano) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_met_fila1_test6
    f1 = self.fila1
    pgas = f1.chromatographical.num_met * self.p_fila1_test6
    return pgas
  end

  def p_met_fila2_test6
    f2 = self.fila2   
    pgas = f2.chromatographical.num_met * self.p_fila2_test6
    return pgas
  end

  def p_met_fila3_test6
    f3 = self.fila3   
    pgas = f3.chromatographical.num_met * self.p_fila3_test6
    return pgas
  end

  def p_met_fila4_test6
    f4 = self.fila4   
    pgas = f4.chromatographical.num_met * self.p_fila4_test6
    return pgas
  end

  def p_met_fila5_test6
    f5 = self.fila5   
    pgas = f5.chromatographical.num_met * self.p_fila5_test6
    return pgas
  end

  def p_met_fila6_test6
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CO (monocarbono) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_mon_fila1_test6
    f1 = self.fila1
    pgas = f1.chromatographical.num_mon * self.p_fila1_test6
    return pgas
  end

  def p_mon_fila2_test6
    f2 = self.fila2   
    pgas = f2.chromatographical.num_mon * self.p_fila2_test6
    return pgas
  end

  def p_mon_fila3_test6
    f3 = self.fila3   
    pgas = f3.chromatographical.num_mon * self.p_fila3_test6
    return pgas
  end

  def p_mon_fila4_test6
    f4 = self.fila4   
    pgas = f4.chromatographical.num_mon * self.p_fila4_test6
    return pgas
  end

  def p_mon_fila5_test6
    f5 = self.fila5   
    pgas = f5.chromatographical.num_mon * self.p_fila5_test6
    return pgas
  end

  def p_mon_fila6_test6
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * CO2 (diocarbono) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_dio_fila1_test6
    f1 = self.fila1
    pgas = f1.chromatographical.num_dio * self.p_fila1_test6
    return pgas
  end

  def p_dio_fila2_test6
    f2 = self.fila2   
    pgas = f2.chromatographical.num_dio * self.p_fila2_test6
    return pgas
  end

  def p_dio_fila3_test6
    f3 = self.fila3   
    pgas = f3.chromatographical.num_dio * self.p_fila3_test6
    return pgas
  end

  def p_dio_fila4_test6
    f4 = self.fila4   
    pgas = f4.chromatographical.num_dio * self.p_fila4_test6
    return pgas
  end

  def p_dio_fila5_test6
    f5 = self.fila5   
    pgas = f5.chromatographical.num_dio * self.p_fila5_test6
    return pgas
  end

  def p_dio_fila6_test6
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H4 (etileno) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eti_fila1_test6
    f1 = self.fila1
    pgas = f1.chromatographical.num_eti * self.p_fila1_test6
    return pgas
  end

  def p_eti_fila2_test6
    f2 = self.fila2   
    pgas = f2.chromatographical.num_eti * self.p_fila2_test6
    return pgas
  end

  def p_eti_fila3_test6
    f3 = self.fila3   
    pgas = f3.chromatographical.num_eti * self.p_fila3_test6
    return pgas
  end

  def p_eti_fila4_test6
    f4 = self.fila4   
    pgas = f4.chromatographical.num_eti * self.p_fila4_test6
    return pgas
  end

  def p_eti_fila5_test6
    f5 = self.fila5   
    pgas = f5.chromatographical.num_eti * self.p_fila5_test6
    return pgas
  end

  def p_eti_fila6_test6
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H6 (etano) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eta_fila1_test6
    f1 = self.fila1
    pgas = f1.chromatographical.num_eta * self.p_fila1_test6
    return pgas
  end

  def p_eta_fila2_test6
    f2 = self.fila2   
    pgas = f2.chromatographical.num_eta * self.p_fila2_test6
    return pgas
  end
  
  def p_eta_fila3_test6
    f3 = self.fila3   
    pgas = f3.chromatographical.num_eta * self.p_fila3_test6
    return pgas
  end

  def p_eta_fila4_test6
    f4 = self.fila4   
    pgas = f4.chromatographical.num_eta * self.p_fila4_test6
    return pgas
  end

  def p_eta_fila5_test6
    f5 = self.fila5   
    pgas = f5.chromatographical.num_eta * self.p_fila5_test6
    return pgas
  end

  def p_eta_fila6_test6
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE P * C2H2 (acetileno) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_ace_fila1_test6
    f1 = self.fila1
    pgas = f1.chromatographical.num_ace * self.p_fila1_test6
    return pgas
  end

  def p_ace_fila2_test6
    f2 = self.fila2   
    pgas = f2.chromatographical.num_ace * self.p_fila2_test6
    return pgas
  end

  def p_ace_fila3_test6
    f3 = self.fila3   
    pgas = f3.chromatographical.num_ace * self.p_fila3_test6
    return pgas
  end

  def p_ace_fila4_test6
    f4 = self.fila4   
    pgas = f4.chromatographical.num_ace * self.p_fila4_test6
    return pgas
  end

  def p_ace_fila5_test6
    f5 = self.fila5   
    pgas = f5.chromatographical.num_ace * self.p_fila5_test6
    return pgas
  end

  def p_ace_fila6_test6
    return 0
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_sum_filas_test6
    psum = self.p_fila1_test6 + self.p_fila2_test6 + self.p_fila3_test6 + self.p_fila4_test6 + self.p_fila5_test6 + self.p_fila6_test6
    return psum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P2 para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p2_sum_filas_test6
    p2sum = self.p2_fila1_test6 + self.p2_fila2_test6 + self.p2_fila3_test6 + self.p2_fila4_test6 + self.p2_fila5_test6 + self.p2_fila6_test6
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * H2 (hidrogeno) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_hid_sum_filas_test6
    p2sum = self.p_hid_fila1_test6 + self.p_hid_fila2_test6 + self.p_hid_fila3_test6 + self.p_hid_fila4_test6 + self.p_hid_fila5_test6 + self.p_hid_fila6_test6
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CH4 (metano) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_met_sum_filas_test6
    p2sum = self.p_met_fila1_test6 + self.p_met_fila2_test6 + self.p_met_fila3_test6 + self.p_met_fila4_test6 + self.p_met_fila5_test6 + self.p_met_fila6_test6
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CO (mcarbono) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_mon_sum_filas_test6
    p2sum = self.p_mon_fila1_test6 + self.p_mon_fila2_test6 + self.p_mon_fila3_test6 + self.p_mon_fila4_test6 + self.p_mon_fila5_test6 + self.p_mon_fila6_test6
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * CO2 (diocarbono) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_dio_sum_filas_test6
    p2sum = self.p_dio_fila1_test6 + self.p_dio_fila2_test6 + self.p_dio_fila3_test6 + self.p_dio_fila4_test6 + self.p_dio_fila5_test6 + self.p_dio_fila6_test6
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H4 (etileno) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eti_sum_filas_test6
    p2sum = self.p_eti_fila1_test6 + self.p_eti_fila2_test6 + self.p_eti_fila3_test6 + self.p_eti_fila4_test6 + self.p_eti_fila5_test6 + self.p_eti_fila6_test6
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H6 (etano) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_eta_sum_filas_test6
    p2sum = self.p_eta_fila1_test6 + self.p_eta_fila2_test6 + self.p_eta_fila3_test6 + self.p_eta_fila4_test6 + self.p_eta_fila5_test6 + self.p_eta_fila6_test6
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE SUMATORIA P * C2H2 (acetileno) para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def p_ace_sum_filas_test6
    p2sum = self.p_ace_fila1_test6 + self.p_ace_fila2_test6 + self.p_ace_fila3_test6 + self.p_ace_fila4_test6 + self.p_ace_fila5_test6 + self.p_ace_fila6_test6
    return p2sum
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def hid_fila1_test6
    sumgas = self.sum_total_hid
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def met_fila1_test6
    sumgas = self.sum_total_met
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE moncarbono para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def mon_fila1_test6
    sumgas = self.sum_total_mon
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def dio_fila1_test6
    sumgas = self.sum_total_dio
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def eti_fila1_test6
    sumgas = self.sum_total_eti
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def eta_fila1_test6
    sumgas = self.sum_total_eta
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def ace_fila1_test6
    sumgas = self.sum_total_ace
    return sumgas
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno por dia para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_hid_fila1_test6
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (6*self.p_hid_sum_filas_test6) - (self.p_sum_filas_test6 * self.hid_fila1_test6)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (6*self.p2_sum_filas_test6) - (self.p_sum_filas_test6 * self.p_sum_filas_test6)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE hidrogeno por año para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_hid_fila1_test6
     self.day_hid_fila1_test6 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano por dia para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_met_fila1_test6
    # ( 4 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (6*self.p_met_sum_filas_test6) - (self.p_sum_filas_test6 * self.met_fila1_test6)
    # ( 4 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (6*self.p2_sum_filas_test6) - (self.p_sum_filas_test6 * self.p_sum_filas_test6)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE metano por año para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_met_fila1_test6
     self.day_met_fila1_test6 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE monocarbono por dia para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_mon_fila1_test6
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (6*self.p_mon_sum_filas_test6) - (self.p_sum_filas_test6 * self.mon_fila1_test6)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (6*self.p2_sum_filas_test6) - (self.p_sum_filas_test6 * self.p_sum_filas_test6)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE monocarbono por año para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_mon_fila1_test6
     self.day_mon_fila1_test6 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono por dia para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_dio_fila1_test6
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (6*self.p_dio_sum_filas_test6) - (self.p_sum_filas_test6 * self.dio_fila1_test6)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (6*self.p2_sum_filas_test6) - (self.p_sum_filas_test6 * self.p_sum_filas_test6)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE diocarbono por año para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_dio_fila1_test6
     self.day_dio_fila1_test6 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno por dia para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_eti_fila1_test6
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (6*self.p_eti_sum_filas_test6) - (self.p_sum_filas_test6 * self.eti_fila1_test6)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (6*self.p2_sum_filas_test6) - (self.p_sum_filas_test6 * self.p_sum_filas_test6)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etileno por año para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_eti_fila1_test6
     self.day_eti_fila1_test6 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano por dia para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_eta_fila1_test6
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (6*self.p_eta_sum_filas_test6) - (self.p_sum_filas_test6 * self.eta_fila1_test6)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (6*self.p2_sum_filas_test6) - (self.p_sum_filas_test6 * self.p_sum_filas_test6)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE etano por año para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_eta_fila1_test6
     self.day_eta_fila1_test6 * 365
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno por dia para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def day_ace_fila1_test6
    # ( 3 * sumatoria de p*gas ) -(sumatoria de p * sumatoria de gas )
    numerador = (6*self.p_ace_sum_filas_test6) - (self.p_sum_filas_test6 * self.ace_fila1_test6)
    # ( 3 * sumatoria de p2 ) -(sumatoria de p * sumatoria de gas )
    denominador = (6*self.p2_sum_filas_test6) - (self.p_sum_filas_test6 * self.p_sum_filas_test6)
    calc = (numerador / denominador)
    return calc
  end

  # # # # # # # # # # # # # # # # # # # 
  #  CALCULO DE acetileno por año para 6 muestras
  # # # # # # # # # # # # # # # # # # # 

  def year_ace_fila1_test6
     self.day_ace_fila1_test6 * 365
  end



end 
