class ArticlesController < ActionController::API

include Paginable
  def index
    paginated = paginate(Article.recent)
    options = { meta:paginated.meta.to_h, links: paginated.links.to_h } #article links, use .to_h to convert items into hash
    render json: serializer.new(paginated.items, options), status: :ok
  end

  def serializer
    ArticleSerializer
  end


end
