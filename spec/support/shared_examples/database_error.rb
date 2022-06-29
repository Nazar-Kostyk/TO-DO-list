# frozen_string_literal: true

RSpec.shared_examples 'database error' do
  let(:expected_error) do
    {
      details: {
        title: I18n.t('error_messages.database_error.title'),
        detail: I18n.t('error_messages.database_error.detail')
      },
      status: :unprocessable_entity
    }
  end

  it 'returns correct error' do
    expect(subject.error).to eq(expected_error)
  end
end
