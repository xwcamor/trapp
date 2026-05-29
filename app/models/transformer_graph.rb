class TransformerGraph < ApplicationRecord
  before_save :assign_license_date
  before_create :set_expiration_days

  # Método para mostrar fecha formateada
  def str_vigence
    self.date_url_created.strftime("%d-%m-%Y")
  end

  private

  def assign_license_date
    if new_record? || will_save_change_to_comment?
      self.date_url_created = Date.today
    end
  end

  def set_expiration_days
  	# expira en 60 segun quickchart, pero no hay que esperar!
    self.day_expiration = 40  # se asigna 40 por seguridad y precauciòn antes que caduque
  end
end
