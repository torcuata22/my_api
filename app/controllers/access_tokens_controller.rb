class AccessTokensController < ApplicationController
  def create
    render json:{}, status: 401
  end
end
