# frozen_string_literal: true

RSpec.describe Common::Schemas::CreateUserSchema do
  subject(:schema) { described_class.call(input) }

  context 'when all required fields are provided' do
    let(:password) { Faker::Lorem.characters(number: 10) }
    let(:input) do
      {
        name: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password
      }
    end

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
