# frozen_string_literal: true

RSpec.describe ToDoLists::CreateParamsValidator do
  subject(:validator) { described_class.new.call(input) }

  context 'when valid params provided' do
    let(:input) { { title: Faker::Lorem.sentence, description: Faker::Lorem.paragraph } }

    it { is_expected.to be_a_success }
  end

  context 'when invalid params provided' do
    context 'when title is invalid' do
      context 'when title is missing' do
        let(:input) { {} }

        it { is_expected.to be_a_failure }
      end

      context 'when title size is less than the minimum allowed' do
        let(:input) { { title: Faker::Lorem.characters(number: ToDoList::TITLE_MIN_LENGTH - 1) } }
        let(:expected_error_message) do
          I18n.t('dry_validation.errors.under_minimum_length', field: :title, length: ToDoList::TITLE_MIN_LENGTH)
        end

        it { is_expected.to be_a_failure }

        it 'sets the correct error message' do
          expect(validator.errors[:title]).to include(expected_error_message)
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
end
