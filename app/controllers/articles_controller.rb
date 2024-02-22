class ArticlesController < ActionController::API
  def index
    #articles = Article.all returned articles oldest to new
    articles = Article.recent #returns articles in proper order: new to old
    render json: serializer.new(articles), status: :ok
  end

  def serializer
    ArticleSerializer
  end



end
