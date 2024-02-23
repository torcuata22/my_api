class ArticlesController < ActionController::API

  def index
    #articles = Article.all returned articles oldest to new
    articles = Article.recent #returns articles in proper order: new to old
    paginated = paginator.call(
      articles,
      params: pagination_params,
      base_url: request.url
    )
    #article links, use .to_h to convert items into hash
    options = { meta:paginated.meta.to_h, links: paginated.links.to_h }

    render json: serializer.new(paginated.items, options), status: :ok
  end

  def serializer
    ArticleSerializer
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

 def pagination_params
  params.permit![:page]
 end




end
