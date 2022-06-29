# frozen_string_literal: true

RSpec.describe Sessions::CreateParamsValidator do
  subject(:validator) { described_class.new.call(input) }

  context 'when valid params provided' do
    let(:input) do
      {
        email: Faker::Internet.email,
        password: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH)
      }
    end

    it { is_expected.to be_a_success }
  end

  context 'when email is invalid' do
    context 'when email is missing' do
      let(:input) { {} }

      it { is_expected.to be_a_failure }
    end

    context 'when email is in the wrong format' do
      let(:input) { { email: Faker::Lorem.word } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.invalid_format', field: :email, format_name: :email)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(subject.errors[:email]).to include(expected_error_message)
      end
    end
  end
end
