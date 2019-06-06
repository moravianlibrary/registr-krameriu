class LibrariesController < ApplicationController
  before_action :set_library, only: [:history, :show, :edit, :update, :destroy, :logo, :thumb]
  before_action :ensure_login, only: [:history, :new, :edit, :create, :update, :destroy]
  # GET /libraries
  # GET /libraries.json
  def index
    @libraries = Library.all
    if params[:android]
      @libraries = @libraries.where(android:params[:android])
    end
    if params[:ios]
      @libraries = @libraries.where(ios:params[:ios])
    end
    if params[:sort]
        @libraries = @libraries.order(params[:sort], :id)
    else
      @libraries = @libraries.order(:id)
    end

    @last_update = nil
    @documents_all = Library.sum_of_all_documents
    @documents_public = Library.sum_of_public_documents
    helper = Helper.first
    @last_update = helper.last_update if helper
  end

  # GET /libraries/1
  # GET /libraries/1.json
  def show
  end

  def history
  end

  # GET /libraries/new
  def new
    @library = Library.new
  end

  # GET /libraries/1/edit
  def edit
  end

  def logo
    redirect_to @library.logo.url(:medium)
  end

  def thumb
    redirect_to @library.logo.url(:thumb)
  end

  # POST /libraries
  # POST /libraries.json
  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        format.html { redirect_to @library, notice: 'Knihovna byla vytvořena.' }
        format.json { render :show, status: :created, location: @library }
      else
        format.html { render :new }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /libraries/1
  # PATCH/PUT /libraries/1.json
  def update
    respond_to do |format|
      if @library.update(library_params)
        format.html { redirect_to @library, notice: 'Knihovna byla upravena.' }
        format.json { render :show, status: :ok, location: @library }
      else
        format.html { render :edit }
        format.json { render json: @library.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /libraries/1
  # DELETE /libraries/1.json
  def destroy
    @library.destroy
    respond_to do |format|
      format.html { redirect_to libraries_url, notice: 'Knihovna byla odstraněna.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library
      @library = Library.find_by(code: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def library_params
      params.require(:library).permit(:name, :name_en, :sigla, :oai_provider, :new_client_url, :web, :street, :city, :zip, :longitude, :latitude, :code, :url, :version, :android, :ios, :k4_client, :k5_client, :alt_client_url, :alt_client_universal, :logo)
    end
end
