class LibrariesController < ApplicationController
  before_action :set_library, only: [:show, :edit, :update, :destroy]
  before_action :ensure_login, only: [:new, :edit, :create, :update, :destroy]
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
      if params[:desc]
        #@libraries = @libraries.order(params[:sort] :desc)
      else
        @libraries = @libraries.order(params[:sort])
      end
    else
      @libraries = @libraries.order(params[:id])
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

  # GET /libraries/new
  def new
    @library = Library.new
  end

  # GET /libraries/1/edit
  def edit
  end

  # POST /libraries
  # POST /libraries.json
  def create
    @library = Library.new(library_params)

    respond_to do |format|
      if @library.save
        format.html { redirect_to @library, notice: 'Library was successfully created.' }
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
        format.html { redirect_to @library, notice: 'Library was successfully updated.' }
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
      format.html { redirect_to libraries_url, notice: 'Library was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_library
      @library = Library.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def library_params
      params.require(:library).permit(:name, :code, :url, :version, :android, :ios, :k4_client, :k5_client, :alt_client_url, :alt_client_universal)
    end
end
