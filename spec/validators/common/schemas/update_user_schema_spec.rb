# frozen_string_literal: true

RSpec.describe Common::Schemas::UpdateUserSchema do
  subject(:schema) { described_class.call(input) }

  context 'when all required fields are provided' do
    let(:input) { { current_password: Faker::Lorem.characters(number: 10) } }

    it { is_expected.to be_a_success }
  end

  context 'when some required fields are missing' do
    let(:input) { {} }

    it { is_expected.to be_failure }

    it 'provides failure messages' do
      expect(schema.errors).to be_present
    end
  end
end
