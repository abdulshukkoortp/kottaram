class SplitwisesController < ApplicationController
  before_action :set_splitwise, only: [:show, :edit, :update, :destroy]

  # GET /splitwises
  # GET /splitwises.json
  def index
    @date_time = date_time
    @splitwises = Splitwise.analysis(@date_time)
  end

  # GET /splitwises/1
  # GET /splitwises/1.json
  def show
  end

  # GET /splitwises/new
  def new
    @splitwise = Splitwise.new
  end

  # GET /splitwises/1/edit
  def edit
  end

  # POST /splitwises
  # POST /splitwises.json
  def create
    @splitwise = Splitwise.new(splitwise_params)

    respond_to do |format|
      if @splitwise.save
        format.html { redirect_to @splitwise, notice: 'Splitwise was successfully created.' }
        format.json { render :show, status: :created, location: @splitwise }
      else
        format.html { render :new }
        format.json { render json: @splitwise.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /splitwises/1
  # PATCH/PUT /splitwises/1.json
  def update
    respond_to do |format|
      if @splitwise.update(splitwise_params)
        format.html { redirect_to @splitwise, notice: 'Splitwise was successfully updated.' }
        format.json { render :show, status: :ok, location: @splitwise }
      else
        format.html { render :edit }
        format.json { render json: @splitwise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /splitwises/1
  # DELETE /splitwises/1.json
  def destroy
    @splitwise.destroy
    respond_to do |format|
      format.html { redirect_to splitwises_url, notice: 'Splitwise was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def analysis
    @date_time = date_time
    @monthly_purchase = Splitwise.analysis(@date_time)
    set_pie_diagram
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_splitwise
      @splitwise = Splitwise.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def splitwise_params
      params[:splitwise][:created_by] = current_user.id
      params[:splitwise][:purchased_by] ||= current_user.id
      params.require(:splitwise).permit(:quantity, :price, :remaining_quantity,
       :purchased_at, :created_by, :item_name, :description, :purchased_by)
    end

    def set_pie_diagram
      @chart = LazyHighCharts::HighChart.new('pie') do |f|
        f.chart({:defaultSeriesType=>"pie" ,
          :margin=> [50, 200, 60, 170]} )
        series = {
                 :type=> 'pie',
                 :name=> 'Monthly Investment Share',
                 :data=> collect_data_of_payment
        }
        f.series(series)
        f.options[:title][:text] = "Monthly Investment Details"
        f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
        f.plot_options(:pie=>{
          :allowPointSelect=>true,
          :cursor=>"pointer" ,
          :dataLabels=>{
            :enabled=>true,
            :color=>"red",
            :style=>{
              :font=>"13px Trebuchet MS, Verdana, sans-serif"
            }
          }
        })
      end
    end

    def collect_data_of_payment
      payment_data = []
      @monthly_purchase.all.collect(&:purchasee).uniq.compact.each do |user|
        payment_data << [user.first_name, user.spent_amount(@date_time)]
      end
      payment_data
    end
end
