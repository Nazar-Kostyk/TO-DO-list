# frozen_string_literal: true

RSpec.describe ToDoLists::UpdateParamsValidator do
  subject(:validator) { described_class.new.call(input) }

  context 'when valid params provided' do
    let(:input) do
      {
        id: SecureRandom.uuid,
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph
      }
    end

    it { is_expected.to be_a_success }
  end

  context 'when invalid params provided' do
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

    context 'when title exceeds the size limit' do
      let(:input) { { title: Faker::Lorem.characters(number: ToDoList::TITLE_MAX_LENGTH + 1) } }
      let(:expected_error_message) do
        I18n.t('dry_validation.errors.exceeds_maximum_length', field: :title, length: ToDoList::TITLE_MAX_LENGTH)
      end

      it { is_expected.to be_a_failure }

      it 'sets the correct error message' do
        expect(validator.errors[:title]).to include(expected_error_message)
      end
    end
  end
end
