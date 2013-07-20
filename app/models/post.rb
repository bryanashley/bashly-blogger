class Post < ActiveRecord::Base
  scope :category, -> (* tags){where('tags @> ARRAY[?]', tags)}
  scope :search_all, -> (query){ 
    where("to_tsvector('english', content) @@ #{sanitize_query(query)}")
  }
  belongs_to :user
  has_many :kudos
  has_many :comments
  
  attr_accessor :tagline
  validates_presence_of :content, :subtitle, :title, :tagline
  before_create :form_tags

  def self.sanitize_query(query, conjunction=' && ')
    "(" + tokenize_query(query).map{|t| term(t)}.join(conjunction) + ")"
  end

  def self.tokenize_query(query)
    query.split(/(\s|[&|:])+/)
  end

  def self.term(t)
    # Strip leading apostrophes, they are never legal, "'ok" becomes "ok"
    t = t.gsub(/^'+/,'')
    # Strip any *s that are not at the end of the term
    t = t.gsub(/\*[^$]/,'')
    # Rewrite "sear*" as "sear:*" to support wildcard matching on terms
    t = t.gsub(/\*$/,':*')
    # If the only remaining text is a wildcard, return an empty string
    t = "" if t.match(/^[:* ]+$/)

    "to_tsquery('english', #{quote_value t})"
  end
  
  private 

  def form_tags
    self.tags = self.tagline.split(",").map{|t| t.strip()}
  end



end
