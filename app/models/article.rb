class Article < ActiveRecord::Base
  attr_accessible :click_num, :content, :title, :user_id, :description

  has_many :comments, class_name: 'Comments'

  validates :title,  presence: true
end
