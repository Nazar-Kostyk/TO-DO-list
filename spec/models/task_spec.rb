# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id            :uuid             not null, primary key
#  is_completed  :boolean          default(FALSE)
#  position      :integer          not null
#  title         :string(255)      default("Untitled")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  to_do_list_id :uuid             not null
#
# Indexes
#
#  index_tasks_on_to_do_list_id               (to_do_list_id)
#  index_tasks_on_to_do_list_id_and_position  (to_do_list_id,position) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (to_do_list_id => to_do_lists.id)
#
RSpec.describe Task, type: :model do
  it 'has correct parrent' do
    expect(subject).to be_a_kind_of(ApplicationRecord)
  end

  describe 'associations' do
    it { is_expected.to belong_to(:to_do_list).class_name('ToDoList') }
  end

  describe 'constants' do
    it 'defines TITLE_MAX_LENGTH' do
      expect(described_class.const_defined?(:TITLE_MAX_LENGTH)).to be true
    end
  end

  describe '#update_position' do
    let!(:to_do_list) { create(:to_do_list_with_tasks) }

    context 'when new_position is lower that the current position' do
      let(:task) { to_do_list.tasks.last }
      let(:new_position) { to_do_list.tasks.first.position }

      it 'updates the task' do
        task.update_position(new_position)
        expect(task.position).to eq(new_position)
      end
    end

    context 'when new_position is higher than the current position' do
      let(:task) { to_do_list.tasks.first }
      let(:new_position) { to_do_list.tasks.last.position }

      it 'updates the task' do
        task.update_position(new_position)
        expect(task.position).to eq(new_position)
      end
    end

    context 'when new_position is the same as the current position' do
      let(:task) { to_do_list.tasks.sample }
      let(:new_position) { task.position }

      it 'doesn\'t update the task' do
        task.update_position(new_position)
        expect(task).not_to receive(:update!)
      end
    end

    context 'when an error ocuured during the transaction' do
      before do
        allow_any_instance_of(described_class).to receive(:update!).and_raise(ActiveRecord::RecordInvalid)
      end

      let(:task) { to_do_list.tasks.sample }
      let(:new_position) { to_do_list.tasks.where.not(id: task.id).pluck(:position).sample }

      it 'returns false' do
        expect(task.update_position(new_position)).to be false
      end
    end
  end

  describe '#destroy_record' do
    let!(:to_do_list) { create(:to_do_list_with_tasks) }
    let(:task) { to_do_list.tasks.sample }

    it 'deletes the task' do
      expect { task.destroy_record }.to change(described_class, :count).by(-1)
    end

    context 'when an error ocuured during the transaction' do
      before do
        allow_any_instance_of(described_class).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed)
      end

      it 'returns false' do
        expect(task.destroy_record).to be false
      end
    end
  end
end
