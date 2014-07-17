class Article < ActiveRecord::Base
  attr_accessible :click_num, :content, :title, :user_id
end
