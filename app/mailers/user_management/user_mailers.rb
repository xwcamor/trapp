class UserManagement::UserMailers < ActionMailer::Base

  default from: 'contact.softwarebu@gmail.com'

  def welcome_email(user)
    @user = user
    @url = 'https://tr.dominio.com/'
    @site_name = "TR Hitachi Energy"
    mail(:to => user.email, :subject => 'TR APP - Creación de usuario')
  end

  def changed_password(user)
    @user = user
    @url = 'https://tr.dominio.com/'
    @site_name = "TR Hitachi Energy"
    mail(:to => user.email, :subject => 'TR APP - Contraseña actualizada')
  end

  def reset_password_email(user)
    @user = user
    @password_reset_url = 'https://tr.dominio.com/password_reset?token=' + @user.password_reset_token
    mail(:to => user.email, :subject => 'TR APP - Instrucciones para restablecer la contraseña')
  end

  def created_os(user,os)
    @user = user

    @os = os
    @url = 'https://tr.dominio.com/'
    @site_name = "TR Hitachi Energy"
    mail(:to => user.email, :subject => 'TR APP - Creación de OS')
  end

  def rem_report_issue(user,rem_report_detail_issue_id)
    @user = User.find(1)
    @rem_report_detail_issue = RemReportDetailIssue.find(rem_report_detail_issue_id)
    @rem_report_detail_issue_url =     @rem_report_detail_issue.web_url_link
    @rem_report_detail_issue_comment = @rem_report_detail_issue.comment
    @url = 'https://tr.dominio.com/'
    @site_name = "TR Hitachi Energy"
    mail(:to => @user.email, :subject => 'TR APP - Corregir Reporte.')
  end



end
