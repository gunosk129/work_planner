require 'rails_helper'

RSpec.describe "Workers", type: :request do
  let!(:worker) { Worker.create(name: "John Doe") }

  describe 'GET #index' do

    context 'when worker is found' do
      it 'returns the workers' do
        get "/workers"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).count).to eq(Worker.all.count)
      end
    end
  end

  describe 'GET #show' do

    context 'when worker is found' do
      it 'returns the worker' do
        get "/workers/#{worker.id}"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(worker.id)
      end
    end

    context 'when worker is not found' do
      it 'returns a not found message' do
        get "/workers/#{worker.id+1}"
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('Worker not found')
      end
    end
  end

  describe 'POST #create' do
    context 'when request is valid' do
      let(:worker_params) { { name: 'John Doe' } }

      it 'creates a worker' do
        post "/workers", params: worker_params

        expect(response).to have_http_status(:created)

        expect(JSON.parse(response.body)['name']).to eq('John Doe')
      end
    end

    context 'when request is invalid' do
      let(:worker_params) { { name: '' } }

      it 'returns an error message' do
        post "/workers", params: worker_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']['name'].first).to eq("can't be blank")
      end
    end
  end

  describe "PATCH #update" do

    context "with valid attributes" do
      it "updates the shift" do
        worker_params = { name: "Changed Name" }

        patch "/workers/#{worker.id}", params: worker_params
        expect(worker.reload.name).to eq(worker_params[:name])
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid attributes" do
      it "does not update the shift" do
        worker_params = { name: nil }

        patch "/workers/#{worker.id}", params: worker_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the shift if shoft not found" do
        shift_params = { slot: nil }

        patch "/workers/#{worker.id+111}", params: shift_params
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE worker" do
    it "deletes the worker" do
      expect {
        delete "/workers/#{worker.id}"
      }.to change(Worker, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "does not delete the shift if shift not found" do
      delete "/workers/#{worker.id+111}"
      expect(response).to have_http_status(:not_found)
    end
  end
end
