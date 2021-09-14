# frozen_string_literal: true

RSpec.describe Users::Create::CreateParamsValidator, type: %i[dry_validation] do
  describe '#name' do
    it { is_expected.to validate(:name, :required).filled }
    it { is_expected.to validate(:name, :required).macro_use?(max_length: User::NAME_MAX_LENGTH) }
  end

  describe '#surname' do
    it { is_expected.to validate(:surname, :required).filled }
    it { is_expected.to validate(:surname, :required).macro_use?(max_length: User::SURNAME_MAX_LENGTH) }
  end

  describe '#email' do
    it { is_expected.to validate(:email, :required).filled }
    it { is_expected.to validate(:email, :required).macro_use?(min_length: User::EMAIL_MIN_LENGTH) }
    it { is_expected.to validate(:email, :required).macro_use?(max_length: User::EMAIL_MAX_LENGTH) }
    it { is_expected.to validate(:email, :required).macro_use?(:email_format) }
    it { is_expected.to validate(:email, :required).macro_use?(:email_uniqueness) }
  end

  describe '#password' do
    it { is_expected.to validate(:password, :required).filled }
    it { is_expected.to validate(:password, :required).macro_use?(min_length: User::PASSWORD_MIN_LENGTH) }
    it { is_expected.to validate(:password, :required).macro_use?(max_length: User::PASSWORD_MAX_LENGTH) }
  end

  describe '#password_confirmation' do
    it { is_expected.to validate(:password_confirmation, :required).filled }
    it { is_expected.to validate(:password_confirmation, :required).macro_use?(:passwords_match) }
  end
end
