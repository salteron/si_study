class PostsController < ApplicationController
  def index
    @city_id       = city_id_from_params
    search_query   = search_query_from_params

    # if city's being provided
    search_query << " city_id_#{@city_id}" unless @city_id.zero?

    @posts         = filter_posts(search_query)
    @cities        = City.all
    @cities_h      = @cities.index_by(&:id)

    @facets = Post.facets search_query, :facets => [:city_id]
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  # Строит и выполняет запрос к сфинксу на основе введенных пользователем
  # параметров.
  #
  # Параметры
  #   search_query  -  строка; поисковый запрос на заголовок и содержание
  #                     поста;
  def filter_posts(search_query)
    Post.search(Riddle.escape(search_query), field_weights: { title: 10 })
  end

  private

  def city_id_from_params
    params[:city_id] ? params[:city_id].to_i : 0
  end

  def search_query_from_params
    params[:q] || ''
  end

  def specify_city_to_search(city_id, search_query)
    search_query << " city_id_#{city_id}" unless city_id.zero? # city specified
    search_query
  end
end
