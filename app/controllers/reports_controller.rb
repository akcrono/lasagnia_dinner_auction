class ReportsController < ApplicationController
  def index
  end

  def generate_summary_csv
    send_data User.to_summary_csv, filename: "auction-summary-#{Date.today}.csv"
  end

  def generate_itemized_csv
    send_data User.to_itemized_csv, filename: "auction-itemized-#{Date.today}.csv"
  end
end
