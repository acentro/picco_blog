module PiccoBlog
  class Post < ActiveRecord::Base
    acts_as_taggable_on :tags
    slugged :title

    paginates_per PiccoBlog.posts_per_page

    attr_accessor :author_id

    belongs_to :author, class_name: PiccoBlog.author_class.to_s
    has_many :comments

    before_validation :set_author

    private

      def set_author
        self.author = PiccoBlog.author_class.constantize.find(author_id)
      end
  end
end
