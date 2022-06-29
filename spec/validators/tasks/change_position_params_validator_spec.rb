# frozen_string_literal: true

RSpec.describe Tasks::ChangePositionParamsValidator do
  subject(:validator) { described_class.new.call(input) }

  let!(:to_do_list) { create(:to_do_list_with_tasks) }
  let!(:task) { to_do_list.tasks.sample }

  context 'when valid params provided' do
    let(:new_position) { to_do_list.tasks.where.not(id: task.id).pluck(:position).sample }
    let(:input) { { to_do_list_id: to_do_list.id, id: task.id, new_position: new_position } }

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

    context 'when new_position is less than the minimum allowed' do
      let(:input) { { new_position: -1 } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.min_value', field: :new_position, number: 0)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:new_position]).to include(expected_error_message)
      end
    end

    context 'when new_position is bigger than the maximum allowed' do
      let(:maximum_allowed_position) { to_do_list.tasks.maximum(:position) }
      let(:input) { { to_do_list_id: to_do_list.id, id: task.id, new_position: maximum_allowed_position + 1 } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.max_value', field: :new_position, number: maximum_allowed_position)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:new_position]).to include(expected_error_message)
      end
    end
  end
end
