class Comments < ActiveRecord::Base
  attr_accessible :article_id, :content, :id, :user_id
  belongs_to :article, counter_cache: 'comments_count'
end
