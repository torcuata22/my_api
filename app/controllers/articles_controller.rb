class ArticlesController < ActionController::API

include Paginable
  def index
    paginated = paginate(Article.recent)
    options = { meta:paginated.meta.to_h, links: paginated.links.to_h } #article links, use .to_h to convert items into hash
    render_collection(paginated)
  end

  def show
    article = Article.find(params[:id])
    render json: article, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Article not found' }, status: :not_found
  end
  end

  def serializer
    ArticleSerializer
  end
