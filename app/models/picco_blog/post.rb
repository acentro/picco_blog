module PiccoBlog
  class Post < ActiveRecord::Base
    attr_accessor :author_id

    belongs_to :author, class_name: "User"
    has_many :comments

    before_validation :set_author

    private

      def set_author
        self.author = User.find(author_id)
      end
  end
end
