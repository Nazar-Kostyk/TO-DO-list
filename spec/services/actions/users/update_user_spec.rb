# frozen_string_literal: true

RSpec.describe Actions::Users::UpdateUser do
  subject(:result) { described_class.new(user, params).call }

  describe '#call' do
    let(:password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) }
    let!(:user) { create(:user, password: password) }

    context 'when params are valid' do
      let(:new_password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) }
      let(:params) do
        {
          name: Faker::Name.first_name,
          surname: Faker::Name.last_name,
          email: Faker::Internet.email,
          current_password: password,
          new_password: new_password,
          new_password_confirmation: new_password
        }
      end

      it 'returns correct payload' do
        expect(result.payload).to eq(user)
      end

      context 'when wrong password provided' do
        let(:params) do
          {
            name: Faker::Name.first_name,
            surname: Faker::Name.last_name,
            email: Faker::Internet.email,
            current_password: Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH),
            new_password: new_password,
            new_password_confirmation: new_password
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

      context 'when database error occured' do
        before do
          allow_any_instance_of(User).to receive(:update).and_return(nil)
        end

        it_behaves_like 'database error'
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
