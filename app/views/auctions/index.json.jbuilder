json.array!(@auctions) do |auction|
  json.extract! auction, :id, :user_id, :value
  json.url auction_url(auction, format: :json)
end
