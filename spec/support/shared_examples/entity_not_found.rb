# frozen_string_literal: true

RSpec.shared_examples 'entity not found' do |model|
  let(:expected_body) do
    {
      'errors' => [
        {
          'title' => I18n.t("error_messages.#{model.name.underscore}_not_found.title"),
          'detail' => I18n.t("error_messages.#{model.name.underscore}_not_found.detail")
        }
      ]
    }
  end

  it 'returns not_found' do
    expect(response).to be_not_found
    expect(JSON.parse(response.body)).to eq(expected_body)
  end
end
