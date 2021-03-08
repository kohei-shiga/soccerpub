class ArticleForm
  include ActiveModel::Model

  attr_accessor :title, :tag_names, :user_id
  attr_writer :content

  delegate :persisted?, to: :article

  with_options presence: true do
    validates :title
    validates :content
  end

  def initialize(attributes={}, article: Article.new)
    @article = article
    attributes ||= default_attributes
    super(attributes)
    set_article
  end

  def save 
    article.update!(title: title, content: content, user_id: user_id)
    tag_list = tag_names.split(',')
    tag_list.map!(&:strip)
    current_tags = article.attached_tags.pluck(:name) unless article.attached_tags.nil?
    old_tags = current_tags - tag_list
    new_tags = tag_list - current_tags
    
    old_tags.each do |old_name|
      article.attached_tags.delete(Tag.find_by(name: old_name))
    end
    
    new_tags.each do |new_name|
      article_tag = Tag.find_or_create_by(name: new_name)
      article.attached_tags << article_tag
    end
  end

  def to_model
    article
  end

  attr_reader :article

  def default_attributes
    {
      title: article.title,
      content: article.content,
      tag_names: article.tags.pluck(:name).join(',')
    }
  end

  def set_article
    @rich_text_article = Article.new(title: title, content: @content)
  end

  def content
    @rich_text_article.content
  end

end
