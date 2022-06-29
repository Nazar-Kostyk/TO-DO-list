# frozen_string_literal: true

RSpec.describe Users::UpdateParamsValidator do
  subject(:validator) { described_class.new.call(input) }

  context 'when valid params provided' do
    let(:new_password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH + 1) }
    let(:input) do
      {
        name: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        email: Faker::Internet.email,
        current_password: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH),
        new_password: new_password,
        new_password_confirmation: new_password
      }
    end

    it { is_expected.to be_a_success }

    context 'when optional fields are not provided' do
      let(:input) { { current_password: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) } }

      it { is_expected.to be_a_success }
    end
  end

  context 'when name is invalid' do
    context 'when name exceeds size limit' do
      let(:input) { { name: Faker::Lorem.characters(number: User::NAME_MAX_LENGTH + 1) } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.exceeds_maximum_length', field: :name, length: User::NAME_MAX_LENGTH)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:name]).to include(expected_error_message)
      end
    end
  end

  context 'when surname is invalid' do
    context 'when surname exceeds size limit' do
      let(:input) { { surname: Faker::Lorem.characters(number: User::SURNAME_MAX_LENGTH + 1) } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.exceeds_maximum_length', field: :surname, length: User::SURNAME_MAX_LENGTH)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:surname]).to include(expected_error_message)
      end
    end
  end

  context 'when email is invalid' do
    context 'when email size is less than the minimum allowed' do
      let(:input) { { email: Faker::Lorem.characters(number: User::EMAIL_MIN_LENGTH - 1) } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.under_minimum_length', field: :email, length: User::EMAIL_MIN_LENGTH)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:email]).to include(expected_error_message)
      end
    end

    context 'when email exceeds size limit' do
      let(:input) { { email: Faker::Lorem.characters(number: User::EMAIL_MAX_LENGTH + 1) } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.exceeds_maximum_length', field: :email, length: User::EMAIL_MAX_LENGTH)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:email]).to include(expected_error_message)
      end
    end

    context 'when email is in the wrong format' do
      let(:input) { { email: Faker::Lorem.word } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.invalid_format', field: :email, format_name: :email)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:email]).to include(expected_error_message)
      end
    end

    context 'when email is not unique' do
      let(:user) { create(:user) }
      let(:input) { { email: user.email } }
      let(:expected_error_message) { I18n.t('dry_validation.errors.not_unique', field: :email) }

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:email]).to include(expected_error_message)
      end
    end
  end

  context 'when current_password is invalid' do
    context 'when current_password is missing' do
      let(:input) { {} }

      it { is_expected.to be_a_failure }
    end
  end

  context 'when new_password is invalid' do
    context 'when new_password size is less than the minimum allowed' do
      let(:input) { { new_password: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH - 1) } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.under_minimum_length', field: :new_password, length: User::PASSWORD_MIN_LENGTH)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:new_password]).to include(expected_error_message)
      end
    end

    context 'when new_password exceeds size limit' do
      let(:input) { { new_password: Faker::Lorem.characters(number: User::PASSWORD_MAX_LENGTH + 1) } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.exceeds_maximum_length', field: :new_password, length: User::PASSWORD_MAX_LENGTH)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:new_password]).to include(expected_error_message)
      end
    end
  end

  context 'when new_password_confirmation is invalid' do
    context 'when new_password_confirmation does not match the password' do
      let(:input) do
        {
          new_password: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH),
          new_password_confirmation: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH + 1)
        }
      end
      let(:expected_error_message) { I18n.t('dry_validation.errors.passwords_do_not_match') }

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:new_password_confirmation]).to include(expected_error_message)
      end
    end
  end
end
