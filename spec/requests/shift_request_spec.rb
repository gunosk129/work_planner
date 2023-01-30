require 'rails_helper'

RSpec.describe "Shifts", type: :request do
  let!(:worker) { Worker.create(name: "John Doe") }

  describe 'GET #index' do
    let!(:shift) { Shift.create(worker: worker, slot: :zero_to_eight, date: Date.today) }

    context 'when worker is found' do
      it 'returns the shifts' do
        get "/workers/#{worker.id}/shifts"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).count).to eq(worker.shifts.count)
      end
    end

    context 'when worker is not found' do
      it 'does not return shifts' do
        get "/workers/#{worker.id+111}/shifts"
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new shift" do
        shift_params = { slot: "zero_to_eight", date: Date.today }

        expect do
          post "/workers/#{worker.id}/shifts", params: shift_params
        end.to change(Shift, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "cannot creates a new shift if date is duplicated" do
        Shift.create(worker: worker, slot: "zero_to_eight", date: Date.today)
        shift_params = { slot: "eight_to_sixteen", date: Date.today }

        expect do
          post "/workers/#{worker.id}/shifts", params: shift_params
        end.to change(Shift, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with invalid attributes" do
      it "does not create a new shift" do
        worker = Worker.create(name: "John Doe")
        shift_params = { slot: nil, date: nil }

        expect do
          post "/workers/#{worker.id}/shifts", params: shift_params
        end.to change(Shift, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create the shift if worker not found" do
        shift_params = { slot: "zero_to_eight", date: Date.today }

        expect do
          post "/workers/#{worker.id+1111}/shifts", params: shift_params
        end.to change(Shift, :count).by(0)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH #update" do
    let!(:shift) { Shift.create(worker: worker, slot: "zero_to_eight", date: Date.today) }

    context "with valid attributes" do
      it "updates the shift" do
        shift_params = { slot: "eight_to_sixteen" }

        patch "/workers/#{worker.id}/shifts/#{shift.id}", params: shift_params
        expect(shift.reload.slot).to eq("eight_to_sixteen")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid attributes" do
      it "does not update the shift" do
        shift_params = { slot: nil }

        patch "/workers/#{worker.id}/shifts/#{shift.id}", params: shift_params
        expect(shift.reload.slot).to eq("zero_to_eight")
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the shift if shoft not found" do
        shift_params = { slot: nil }
        patch "/workers/#{worker.id}/shifts/#{shift.id+111}", params: shift_params
        expect(response).to have_http_status(:not_found)
      end

      it "does not update the shift if worker not found" do
        delete "/workers/#{worker.id+111}/shifts/#{shift.id}"
        expect(response).to have_http_status(:not_found)
      end

      it "does not update the shift if date was passed" do
        shift_params = { slot: "eight_to_sixteen", date: "2023-01-01"}

        patch "/workers/#{worker.id}/shifts/#{shift.id}", params: shift_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:shift) { Shift.create(worker: worker, slot: "zero_to_eight", date: Date.today) }
    it "deletes the shift" do
      expect {
        delete "/workers/#{worker.id}/shifts/#{shift.id}"
      }.to change(Shift, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "does not delete the shift if shift not found" do
      delete "/workers/#{worker.id}/shifts/#{shift.id+111}"
      expect(response).to have_http_status(:not_found)
    end

    it "does not delete the shift if worker not found" do
      delete "/workers/#{worker.id+111}/shifts/#{shift.id}"
      expect(response).to have_http_status(:not_found)
    end
  end
end
