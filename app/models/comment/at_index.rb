class Comment::AtIndex < ActiveType::Record[Comment]
  
  scope :order_by_date, -> { order('created_at DESC') }
  
end