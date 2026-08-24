module PiccoBlog
  class Comment < ActiveRecord::Base
    belongs_to :post
    belongs_to :author, optional: true

    validates :body, presence: true

    scope :recent, -> { order(created_at: :desc) }
  end
end
