require 'test_helper'
require 'generators/picco_blog/install/install_generator'

module PiccoBlog
  class InstallGeneratorTest < Rails::Generators::TestCase
    tests PiccoBlog::Generators::InstallGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
