#encoding:utf-8
class ArticlesController < ActionController::Base
  layout 'application'
  respond_to :html, :xml, :json

  before_filter :authenticate, :only => [:edit, :update, :delete]

  def index
    @articles = Article.page(params[:page]).per(20)
    #render :json => @articles
    @articles.each_with_index do |art, i|
      @articles[i][:comments_num] =  Comments.where({:article_id => art.id}).count()
    end
    respond_with(@articles)
  end

  def show
    @article = Article.find(params[:id])
    respond_with(@article)
  end

  def edit
    @article = Article.find(params[:id])
    respond_with(@article)
  end

  def update
    if request.post?
      @article = Article.find(params[:id])
      if @article.update_attributes({:title=>params[:title],:content=>params[:content], :description=>params[:description]})
        redirect_to :action=> 'index'
      else
        render action: "edit"
      end
    end
  end

  def delete
    @article = Article.find(params[:id])
    @article.destroy()
    redirect_to  :action=> 'index'
  end

  def new
    if request.post?
      content = params[:content]
      if content.present? && (content.slice(0, 4) != 'http')
        content = 'http://' + content
      end

      @article = Article.new({:title=>params[:title], :content=>content, :description=>params[:description]})
      if @article.save
        redirect_to :action=> 'index'
      else
        render action: "new"
      end

    end
  end

  def review
    if request.post?
      @article = Article.find(params[:id])
      @data = {:status => false, :msg => "资源不存在！"}
      if !@article.nil?
        click_num = @article.click_num.to_i + 1
        if @article.update_attributes({:click_num => click_num})
          @data[:status] = true
          @data[:id] = @article.id
        else
          @data[:msg] = 'review fail!'
        end
      end
      render :json => @data
    end
  end

  def add
    @data = [1,2,3]
    render :json => @data
  end

  def comments
    @article = Article.find(params[:id])
    @comments = @article.comments.all()
    respond_with(@article, @comments)
  end

  def addcomments
    if request.post?
      @article = Article.find(params[:article_id])
      if @article.nil?
        render :html => 'Link not found!'
        redirect_to :action => 'index'
      else
        @comment = @article.comments.new({:article_id => @article.id, :content => params[:content]})
        if @comment.save
          redirect_to :action => "comments", :id => @article.id
        else
          redirect_to :action => "comments", :id => @article.id
        end
      end
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      user_name = 'admin' && password == 'admin'
    end
  end

end