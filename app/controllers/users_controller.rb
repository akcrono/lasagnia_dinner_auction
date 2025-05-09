class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :send_csv_email]

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:auctions).search(params[:search]).order("users.id ASC").paginate(page: params[:page], per_page: 100)

    if @users.count == 1 && params[:page].nil? && params[:search].present?
      redirect_to user_path(@users.first)
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @auction = Auction.new
    @auctions = @user.auctions.sort_by{ |a| a.paid? ? 1 : 0 }
    @total = @user.total_due
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    unpaid_dinners_count = user_params[:unpaid_dinners].to_i
    @user = User.new(user_params.except(:unpaid_dinners))

    respond_to do |format|
      if @user.save
        @user.track_unpaid_dinners!(unpaid_dinners_count)

        format.html { redirect_to "/numbers/#{@user.id}" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:paying_user]
      @auctions = @user.auctions
      paid = params[:paying_user].keys.first == 'true' ? true : false

      ActiveRecord::Base.transaction do
        @auctions.each do |auction|
          auction.paid = paid
          auction.save!
        end
      end

      if @user.save
        redirect_to @user, notice: 'User was successfully updated.'
      else
        redirect_to @user
      end
    else
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_csv_email
    ParticipantMailer.with(user: @user).auction_summary(report_email).deliver
    flash[:notice] = "Email sent to #{report_email} for participant #{@user.name}"
  rescue => e
    flash[:error] = "Email failed: #{e.message}"
  ensure
    redirect_to @user
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :phone_number, :email, :unpaid_dinners)
  end

  def report_email
    params.require(:email)
  end
end
