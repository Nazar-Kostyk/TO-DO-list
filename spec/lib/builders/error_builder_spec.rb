# frozen_string_literal: true

RSpec.describe Builders::ErrorBuilder do
  let(:dummy_class) { Class.new { extend Builders::ErrorBuilder } }

  describe '#build_validation_errors_details' do
    let(:validation_errors_hash) do
      {
        email: [
          'The email field should be at least 5 characters long.',
          'The email field does not follow the email format.'
        ],
        password: ['The password field should be at least 8 characters long.']
      }
    end
    let(:expected_hash) do
      [
        {
          source: {
            pointer: '/data/attributes/email'
          },
          detail: 'The email field should be at least 5 characters long.'
        },
        {
          source: {
            pointer: '/data/attributes/email'
          },
          detail: 'The email field does not follow the email format.'
        },
        {
          source: {
            pointer: '/data/attributes/password'
          },
          detail: 'The password field should be at least 8 characters long.'
        }
      ]
    end

    it 'returns correct hash' do
      expect(dummy_class.build_validation_errors_details(validation_errors_hash)).to eq(expected_hash)
    end
  end

  describe '#build_error_by_translation_key' do
    let(:status) { :unprocessable_entity }
    let(:translation_key) { 'database_error' }
    let(:expected_hash) do
      {
        status: status,
        details: {
          title: I18n.t("error_messages.#{translation_key}.title"),
          detail: I18n.t("error_messages.#{translation_key}.detail")
        }
      }
    end

    it 'returns correct hash' do
      expect(
        dummy_class.build_error_by_translation_key(status: status, translation_key: translation_key)
      ).to eq(expected_hash)
    end
  end

  # describe '#build_error_details_by_translation_key' do
  #   context 'when the translation for the given key is present' do
  #     let(:translation_key) { 'database_error' }
  #     let(:expected_hash) do
  #       {
  #         title: I18n.t("error_messages.#{translation_key}.title"),
  #         detail: I18n.t("error_messages.#{translation_key}.detail")
  #       }
  #     end

  #     it 'returns correct hash' do
  #       expect(dummy_class.build_error_details_by_translation_key(translation_key)).to eq(expected_hash)
  #     end
  #   end

  #   context 'when the translation for the given key is missing' do
  #     let(:translation_key) { 'missing_translation_key' }

  #     it 'returns correct hash' do
  #       expect(dummy_class.build_error_details_by_translation_key(translation_key)).to eq({})
  #     end
  #   end
  # end
end
