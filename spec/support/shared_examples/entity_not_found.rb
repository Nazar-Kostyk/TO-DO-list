# frozen_string_literal: true

RSpec.shared_examples 'entity not found' do |model|
  let(:expected_error) do
    {
      details: {
        title: I18n.t("error_messages.#{model.name.underscore}_not_found.title"),
        detail: I18n.t("error_messages.#{model.name.underscore}_not_found.detail")
      },
      status: :not_found
    }
  end

  it 'returns not_found' do
    expect(subject.error).to eq(expected_body)
  end
end
