module PiccoBlog
  class Post < ActiveRecord::Base
    extend FriendlyId
    friendly_id :title, use: [:slugged, :history]
    acts_as_taggable_on :tags

    paginates_per PiccoBlog.posts_per_page

    attr_accessor :author_id

    belongs_to :author, class_name: PiccoBlog.author_class.to_s
    has_many :comments

    validates :title, :text, :state, presence: true

    before_validation :set_author

    enum state: [:visible, :hidden]

    private

      def set_author
        self.author = PiccoBlog.author_class.constantize.find(author_id)
      end
  end
end
