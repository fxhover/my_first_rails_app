#encoding: utf-8
class AddCountColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :description, :text
    add_column :articles, :comments_count, :integer
  end
end