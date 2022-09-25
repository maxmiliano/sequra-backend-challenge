class ProcessDisbursementsJob < ApplicationJob
  queue_as :default

  def perform(year = Time.current.year, week = Time.current.strftime("%W").to_i - 1)
    Rails.logger.info "Processing disbursements for year: #{year} and week: #{week}"

    Disbursement.process_disbursements(year, week)

    Rails.logger.info "Finished processing disbursements for year: #{year} and week: #{week}"
  end
end
