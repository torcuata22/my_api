class ArticlesController < ActionController::API
  def index
    render json:{}, status: :ok
  end
end
