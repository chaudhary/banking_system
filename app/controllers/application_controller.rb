class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from AppException do |exception|
    respond_to do |format|
      format.html {}
      format.json { render(json: {server_message: exception.message}, status: 422) }
    end
  end
end
