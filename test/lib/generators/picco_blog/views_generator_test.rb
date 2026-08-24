require 'test_helper'
require 'generators/picco_blog/views/views_generator'

module PiccoBlog
  class ViewsGeneratorTest < Rails::Generators::TestCase
    tests PiccoBlog::Generators::ViewsGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
