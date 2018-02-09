class V1::UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    urls = Url.all.order(created_at: :desc)
    render json: urls
  end

  def show
    render json: url
  end

  def redirect
    url = Url.find_by(url: params.dig(:id))
    if url
      url.increment!(:views)
      redirect_to url.original_url
    else
      render plain: 'Not Found', layout: false
    end
  end

  def new
    url = Url.new(url_params)
    if url.valid?
      render json: url
    else
      render json: { errors: url.errors }, status: 422
    end
  end

  def create
    url = Url.new(url_params)

    if url.save
      render json: url
    else
      render json: { errors: url.errors }, status: 422
    end
  end

  def update
    if url.update_attributes(url_params)
      render json: url
    else
      render json: { errors: url.errors }, status: 422
    end
  end

  def destroy
    url.destroy
    format.json { head :no_content }
  end

  private

  def url
    @url ||= Url.find(params[:id])
  end

  def url_params
    params.require(:url).permit(:url, :original_url)
  end
end
