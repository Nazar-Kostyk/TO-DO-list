# frozen_string_literal: true

RSpec.describe Actions::Users::CreateUser do
  subject(:result) { described_class.new(params).call }

  describe '#call' do
    context 'when params are valid' do
      let(:password) { Faker::Lorem.characters(number: User::PASSWORD_MIN_LENGTH) }
      let(:params) do
        {
          name: Faker::Name.first_name,
          surname: Faker::Name.last_name,
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        }
      end

      it 'creates user' do
        expect { result }.to change(User, :count).by(1)
      end

      it 'returns correct payload' do
        expect(result.payload).to eq(User.last)
      end

      context 'when database error occured' do
        before do
          allow_any_instance_of(User).to receive(:save).and_return(nil)
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
