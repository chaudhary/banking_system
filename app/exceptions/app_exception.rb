class AppException < StandardError

  def initialize(message='Something went wrong! Please try again')
    super(message)
  end
end
