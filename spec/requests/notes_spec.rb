require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe 'Notes', type: :request do
  # rubocop:enable Metrics/BlockLength
  let(:user) { FactoryGirl.create(:user) }
  let(:personality) { FactoryGirl.create(:user_personality, user: user) }
  let(:category) { FactoryGirl.create(:category, user_personality: personality) }
  let(:transaction) { FactoryGirl.create(:transaction, category: category) }
  let(:note) { FactoryGirl.create(:note, tranzaction: transaction) }

  before do
    sign_in user
  end

  describe 'GET routes tests for notes' do
    it 'should show new template' do
      get url_for([:new, personality, category, transaction, :note])
      expect(response.body).to include 'Create note'
      expect(response).to have_http_status(200)
    end

    it 'should show edit template' do
      get url_for([:edit, personality, category, transaction, note])
      expect(response.body).to include 'Update note'
      expect(response).to have_http_status(200)
    end
  end

  describe 'positive POST/PATCH/DELETE routes tests for transactions' do
    it 'should create note' do
      description = 'Desctiption example'
      post url_for([personality, category, transaction, Note.new]),
           params: { note: { description: description } }
      expect(Note.last.description).to eq(description)
      expect(response).to have_http_status(302)
    end

    it 'should update note' do
      new_description = 'Desctiption example42'
      patch url_for([personality, category, transaction, note]),
            params: { note: { description: new_description } }
      note_new_description = Note.find(note.id).description
      expect(note_new_description).to eq(new_description)
      expect(response).to have_http_status(302)
    end

    it 'should delete note' do
      delete url_for([personality, category, transaction, note])
      expect(response).to have_http_status(302)
      expect { Note.find(note.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'negative POST/PATCH/DELETE routes tests for transactions' do
    it 'should restrict access to act with unfamiliar notes' do
      transaction2 = FactoryGirl.create(:transaction)
      get url_for([:edit, personality, category, transaction2, note])
      expect(response).to have_http_status(302)
    end

    it 'should handle record not found error' do
      fake_note_id = 0
      new_description = 'Desctiption example42'
      patch url_for([personality, category, transaction, { note_id: fake_note_id }]),
            params: { note: { description: new_description } }
      expect(response.body).to include "Something wen't wrong"
    end
  end
end
