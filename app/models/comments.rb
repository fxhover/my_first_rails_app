class Comments < ActiveRecord::Base
  attr_accessible :article_id, :content, :id, :user_id
end
