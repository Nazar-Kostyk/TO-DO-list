# frozen_string_literal: true

RSpec.describe AuthenticationService do
  subject(:result) { described_class.new(params).call }

  describe '#call' do
    let!(:password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) }
    let!(:user) { create(:user, password: password) }

    context 'when params are valid' do
      let(:params) { { email: user.email, password: password } }

      it 'returns correct payload' do
        expect(result.payload).to be_present
      end

      context 'when wrong password provided' do
        let(:params) do
          {
            email: user.email,
            password: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH)
          }
        end
        let(:expected_error) do
          {
            details: {
              title: I18n.t('error_messages.wrong_password.title'),
              detail: I18n.t('error_messages.wrong_password.detail')
            },
            status: :unauthorized
          }
        end

        it 'sets error' do
          expect(result.error).to eq(expected_error)
        end
      end

      context 'when user not found' do
        let(:params) { { email: Faker::Internet.email, password: password } }

        it 'raises ActiveRecord::RecordNotFound error' do
          expect { result }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context 'when params are invalid' do
      let(:params) { {} }

      it 'sets error' do
        expect(result.error).to be_present
      end
    end
  end
end
