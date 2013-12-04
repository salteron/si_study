class Post < ActiveRecord::Base
  belongs_to :user, :inverse_of => :posts
  belongs_to :city, :inverse_of => :posts

  define_index('post') do
    indexes :title
    indexes :content
    indexes "'city_id_' || city_id", :as => :city_idx

    set_property :rt => true

    has city_id, :facet => true
  end
end
