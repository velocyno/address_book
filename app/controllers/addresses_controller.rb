class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  # GET /addresses
  # GET /addresses.json
  def index
    @addresses = current_user.addresses.order(:id)

    respond_to do |format|
      format.json { render json: @addresses }
      format.html
    end
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
    respond_to do |format|
      format.json { render json: @address}
      format.html
    end
  end

  # GET /addresses/new
  def new
    @address = current_user.addresses.build
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = current_user.addresses.build(address_params)

    respond_to do |format|
      if @address.save
        format.json { render json: @address }
        format.html { redirect_to @address, notice: 'Address was successfully created.' }
      else
        format.json { render json: @address.errors, status: :unprocessable_entity }
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = current_user.addresses.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:first_name, :last_name, :address1, :address2, :city, :state, :zip_code, :country,
                                      :birthday, :note, :color, :age, :website, :phone, :interest_climb, :interest_dance, :interest_read)
    end
end
