class Comment::AtCreate < ActiveType::Record[Comment]
  
  has_many :votes, as: :voteable
  
  validates :body, presence: true
  validates :creator, presence: true
  validates :post, presence: true
  
end