class PenaltiesController < ApplicationController
  before_action :set_penalty, except: [:new, :index, :create]

  def index
    @date_time = date_time
    @penalties = Penalty.analysis(@date_time)
  end

  def show
  end

  def new
    @penalty = Penalty.new
  end

  def edit
  end

  def create
    @penalty = Penalty.new(penalty_params)

    respond_to do |format|
      if @penalty.save
        format.html { redirect_to @penalty, notice: 'Penalty was successfully created.' }
        format.json { render :show, status: :created, location: @penalty }
      else
        format.html { render :new }
        format.json { render json: @penalty.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @penalty
    respond_to do |format|
      if @penalty.update(penalty_params)
        format.html { redirect_to @penalty, notice: 'penalty was successfully updated.' }
        format.json { render :show, status: :ok, location: @penalty }
      else
        format.html { render :edit }
        format.json { render json: @penalty.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @penalty
    @penalty.destroy
    respond_to do |format|
      format.html { redirect_to penalties_url, notice: 'penalty was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def approve
    authorize @penalty
    @penalty.approver_id = current_user.id
    @penalty.confirmed!
    respond_to do |format|
      format.html { redirect_to penalties_url, notice: 'penalty is approved.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_penalty
      @penalty = Penalty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def penalty_params
      params.require(:penalty).permit(:amount, :creator_id, :date, :description, :user_id)
    end
end
