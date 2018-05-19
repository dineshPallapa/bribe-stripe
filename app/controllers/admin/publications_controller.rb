class Admin::PublicationsController < AdminController
  before_action :find_publication,only: [:show,:edit,:update,:destroy]

  def index
    @publications = Publication.all
  end

  def new
    @publication = Publication.new
  end

  def create
    @publication = Publication.new(publication_params)
    if @publication.save
      redirect_to admin_publication_path(@publication)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @publication.update(publication_params)
      redirect_to admin_publication_path(@publication)
    else
      render :edit
    end
  end

  def destroy
    if @publication.destroy
      redirect_to root_path
    end
  end


  private

  def publication_params
    params.require(:publication).permit(:title,:description,:file_url)
  end

  def find_publication
    @publication = Publication.find(params[:id])
  end

end
