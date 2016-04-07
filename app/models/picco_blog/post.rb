module PiccoBlog
  class Post < ActiveRecord::Base
    attr_accessor :author_id

    belongs_to :author, class_name: PiccoBlog.author_class.to_s
    has_many :comments

    before_validation :set_author

    private

      def set_author
        self.author = PiccoBlog.author_class.find(author_id)
      end
  end
end
