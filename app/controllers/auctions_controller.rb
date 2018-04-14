class AuctionsController < ApplicationController
  before_action :set_auction, only: [:show, :edit, :update, :destroy]

  # GET /auctions
  # GET /auctions.json
  def index
    @auctions = Auction.all
  end

  # GET /auctions/1
  # GET /auctions/1.json
  def show
  end

  # GET /auctions/new
  def new
    @auction = Auction.new
  end

  # GET /auctions/1/edit
  def edit
  end
# style="float: left"
  # POST /auctions
  # POST /auctions.json
  def create
    errors = false
    if params[:multi_winner]
      user_ids = params[:auction][:user_ids].gsub(' ','').split(',')
      user_ids.each do |user_id|
        @auction = Auction.new(auction_params)
        @auction.user_id = user_id
        errors = true unless @auction.save
      end
    else
      @user = User.find(params["user"]["id"])
      count = params[:auction][:quantity].to_i
      count = 1 if count.nil? || count == 0

      count.times do
        @auction = Auction.new(auction_params)
        @auction.user_id = @user.id
        errors = true unless @auction.save
      end
    end
    respond_to do |format|
      unless errors
        format.html { redirect_to @user || "/auctions/new", notice: 'Auction was successfully created.' }
        format.json { render :show, status: :created, location: @auction }
      else
        format.html { render :new }
        format.json { render json: errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auctions/1
  # PATCH/PUT /auctions/1.json
  def update
    respond_to do |format|
      if @auction.update(auction_params)
        format.html { redirect_to @auction, notice: 'Auction was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction }
      else
        format.html { render :edit }
        format.json { render json: @auction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auctions/1
  # DELETE /auctions/1.json
  def destroy
    @user = @auction.user
    @auction.destroy
    respond_to do |format|
      format.html { redirect_to @user, notice: 'Auction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction
      @auction = Auction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_params
      params.require(:auction).permit(:user_id, :value, :name)
    end
end
