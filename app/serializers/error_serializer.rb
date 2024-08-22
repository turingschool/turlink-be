class ErrorSerializer
  def initialize(object, status_code)
    @object = object
    @status_code = status_code.to_s
  end

  def serialize
    {
      errors: format_errors
    }
  end

  private

  def format_errors
    @object.errors.full_messages.map do |message|
      {
        status: @status_code,
        message:
      }
    end
  end
end
