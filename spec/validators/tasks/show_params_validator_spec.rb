# frozen_string_literal: true

RSpec.describe Tasks::ShowParamsValidator do
  subject(:validator) { described_class.new.call(input) }

  context 'when valid params provided' do
    let(:input) { { to_do_list_id: SecureRandom.uuid, id: SecureRandom.uuid } }

    it { is_expected.to be_a_success }
  end

  context 'when invalid params provided' do
    context 'when to_do_list_id is invalid' do
      let(:input) { { to_do_list_id: 'invalid' } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.invalid_format', field: :to_do_list_id, format_name: :UUID)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:to_do_list_id]).to include(expected_error_message)
      end
    end

    context 'when id is invalid' do
      let(:input) { { id: 'invalid' } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.invalid_format', field: :id, format_name: :UUID)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:id]).to include(expected_error_message)
      end
    end
  end
end
