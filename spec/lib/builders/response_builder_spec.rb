# frozen_string_literal: true

RSpec.describe Builders::ResponseBuilder do
  let(:dummy_class) { Class.new { extend Builders::ResponseBuilder } }

  describe '#build_success_response' do
    let(:payload) { Faker::Movies::BackToTheFuture.character }
    let(:expected_result) { OpenStruct.new({ success?: true, payload: payload }) }

    it 'returns correct hash' do
      expect(dummy_class.build_success_response(payload)).to eq(expected_result)
    end
  end

  describe '#build_failure_response' do
    let(:error) { Faker::Lorem.sentence }
    let(:expected_result) { OpenStruct.new({ success?: false, error: error }) }

    it 'returns correct hash' do
      expect(dummy_class.build_failure_response(error)).to eq(expected_result)
    end
  end

  describe '#build_error_response_by_translation_key' do
    let(:status) { :unprocessable_entity }
    let(:translation_key) { 'database_error' }
    let(:expected_result) do
      OpenStruct.new(
        {
          success?: false,
          error: {
            status: status,
            details: {
              title: I18n.t("error_messages.#{translation_key}.title"),
              detail: I18n.t("error_messages.#{translation_key}.detail")
            }
          }
        }
      )
    end

    it 'returns correct hash' do
      expect(
        dummy_class.build_error_response_by_translation_key(status: status, translation_key: translation_key)
      ).to eq(expected_result)
    end
  end
end
