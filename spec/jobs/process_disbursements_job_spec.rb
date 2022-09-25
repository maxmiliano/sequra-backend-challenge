require 'rails_helper'

RSpec.describe ProcessDisbursementsJob, type: :job do
  
  describe "#perform_later" do
    it "should enqueue a job" do
      ActiveJob::Base.queue_adapter = :test
      expect do
        ProcessDisbursementsJob.perform_later
      end.to have_enqueued_job
    end
  end
end
