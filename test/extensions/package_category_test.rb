require 'rubygems'
require 'minitest/autorun'

require './lib/runcible'
require './test/support/repository_support'

module Extensions
  class TestPackageCategory < MiniTest::Unit::TestCase
    def self.before_suite
      self.support = RepositorySupport.new
      @@extension = TestRuncible.server.extensions.package_category
      self.support.create_and_sync_repo(:importer => true)
    end

    def self.after_suite
      self.support.destroy_repo
    end

    def test_content_type
      assert_equal 'package_category', @@extension.content_type
    end

    def test_all
      response = @@extension.all

      assert_equal 200, response.code
      refute_empty response
    end

    def test_find
      id = @@extension.all.sort_by { |p| p['id'] }.first['id']
      response = @@extension.find(id)

      refute_empty response
      assert_equal id, response['id']
    end

    def test_find_by_unit_id
      id = @@extension.all.sort_by { |p| p['id'] }.first['_id']
      response = @@extension.find_by_unit_id(id)

      refute_empty response
      assert_equal id, response['_id']
    end

    def test_find_unknown
      response = @@extension.find_all(['f'])

      assert_empty response
    end

    def test_find_all
      pkgs = @@extension.all.sort_by { |p| p['id'] }
      ids = pkgs[0..2].map { |p| p['id'] }
      response = @@extension.find_all(ids)

      assert_equal 200, response.code
      assert_equal ids.length, response.length
    end

    def test_find_all_by_unit_ids
      id = @@extension.all.sort_by { |p| p['id'] }.first['_id']
      response = @@extension.find_all_by_unit_ids([id])

      refute_empty response
      assert_equal id, response.first['_id']
    end
  end
end
