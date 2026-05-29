class ErrorsController < ApplicationController
  def not_found
    render status: 404, template: "errors/not_found"
  end

  def internal_server_error
    render status: 500, template: "errors/internal_server_error"
  end

  def forbidden
    render status: 403, template: "errors/forbidden"
  end
end
