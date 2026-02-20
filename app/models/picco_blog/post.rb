module PiccoBlog
  class Post < ActiveRecord::Base
    extend FriendlyId
    friendly_id :title, use: [:slugged, :history]
    acts_as_taggable_on :tags
    dragonfly_accessor :featured_image

    paginates_per PiccoBlog.posts_per_page

    attr_accessor :author_id

    author_opts = { optional: true }
    author_opts[:class_name] = PiccoBlog.author_class if PiccoBlog.author_class.present?
    belongs_to :author, **author_opts
    has_many :comments, dependent: :destroy

    validates :title, :text, :state, presence: true
    validates_property :format, of: :featured_image, in: [:jpeg, :jpg, :png], case_sensitive: false,
                        message: "should be either .jpeg, .jpg, .png", if: :featured_image_changed?

    before_validation :set_author

    enum :state, { visible: 0, hidden: 1 }

    private

      def self.search(term)
        posts = self.arel_table
        query_string = "%#{term}%"
        param_matches_string =  ->(param){ 
          posts[param].matches(query_string) 
        } 

        self.where(param_matches_string.(:title).or(param_matches_string.(:text)))
      end

      def set_author
        return unless author_id.present? && PiccoBlog.author_class.present?
        self.author = PiccoBlog.author_class.constantize.find(author_id)
      end
  end
end
