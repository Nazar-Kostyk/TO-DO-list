# frozen_string_literal: true

RSpec.describe Users::Create::CreateParamsValidator, type: %i[dry_validation] do
  describe '#name' do
    it { is_expected.to validate(:name, :required).filled }
  end

  describe '#surname' do
    it { is_expected.to validate(:surname, :required).filled }
  end

  describe '#email' do
    it { is_expected.to validate(:email, :required).filled }
  end

  describe '#password' do
    it { is_expected.to validate(:password, :required).filled }
  end
end
