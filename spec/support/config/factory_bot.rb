# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.append_after do
    FactoryBot.rewind_sequences
  end
end
