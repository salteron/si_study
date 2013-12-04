class PostsController < ApplicationController
  def index
    # title and content filter
    search_string = params[:q] || ""

    # city filter
    city_id = params[:city_id] ? params[:city_id].to_i : City.first.id

    @posts            = filter_posts(search_string, city_id)
    @cities           = City.all
    @selected_city_id = city_id
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  # Строит и выполняет запрос к сфинксу на основе введенных пользователем
  # параметров.
  #
  # Параметры
  #   search_string  -  строка; поисковый запрос на заголовок и содержание
  #                     поста;
  #   city_id        -  число; id города, которому должны принадлежать искомые
  #                     посты.
  def filter_posts(search_string, city_id)
    search_string << " city_id_#{city_id}"

    Post.search(Riddle.escape(search_string), field_weights: { title: 10 })
  end
end
