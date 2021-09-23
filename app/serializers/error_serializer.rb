# frozen_string_literal: true

class ErrorSerializer
  def initialize(errors)
    @errors = errors
  end

  def serializable_hash
    return if @errors.nil?

    json = {}
    new_hash = errors.to_hash(true).map do |k, v|
      v.map do |msg|
        { id: k, title: msg }
      end
    end.flatten
    json[:errors] = new_hash
    json
  end
end

# source
# detail

# {
#   "status": "500",
#   "source": { "pointer": "/data/attributes/reputation" },
#   "title": "The backend responded with an error",
#   "detail": "Reputation service not responding after three requests."
# }
