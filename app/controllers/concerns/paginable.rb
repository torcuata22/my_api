module Paginable
  extend ActiveSupport::Concern

  def paginate(collection)
    paginated = paginator.call(
      collection,
      params: pagination_params,
      base_url: request.url
    )
  end

  def paginator
    JSOM::Pagination::Paginator.new
  end

 def pagination_params
  params.permit![:page]
 end

 def render_collection(paginated)
  options = {
    meta:paginated.meta.to_h,
    links: paginated.links.to_h
  } #article links, use .to_h to convert items into
  result = serializer.new(paginated.items, options)
  render json: result, status: :ok
 end
end
