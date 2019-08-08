# frozen_string_literal: true

require 'test_helper'

module Nac
  class ConfigTest < Minitest::Test
    def test_it_initializes_a_source
      source = Tempfile.new
      config = Config.new(source)

      assert_equal config.source, source
    ensure
      source.close
      source.unlink
    end

    def test_it_initializes_a_template_option
      source = Tempfile.new
      template = { this: { test: { template: true } } }

      config = Config.new(source, template: template)

      assert_equal config.template, template.to_yaml
    ensure
      source.close
      source.unlink
    end

    def test_it_initializes_a_new_config_file_if_it_doesnt_exist
      source = File.join(Dir.tmpdir, 'some_folder',
                         'new_config_file_if_it_doesnt_exist.yaml')

      File.delete(source) if File.exist?(source)

      refute File.exist?(source)

      config = Config.new(source)

      assert File.exist?(config.source)
    end

    def test_it_saves_a_value_in_the_config
      source = Tempfile.new
      config = Config.new(source)

      key = 'my key'
      value = 'Hello, World!'

      config.set(key, value)

      yaml = YAML.load_file(source)

      assert_equal value, yaml[key]
    ensure
      source.close
      source.unlink
    end

    def test_the_content_can_be_reinitialized_with_template_data
      source = Tempfile.new
      key = :name
      name = 'Olive'

      config = Config.new(source, template: { key => name }, init!: true)

      assert_equal config.get(key), name
    ensure
      source.close
      source.unlink
    end

    def test_it_retrieves_a_value_from_the_config
      key = :name
      name = 'Olive'

      source = Tempfile.new
      source.write({ key => name }.to_yaml)
      source.rewind

      config = Config.new(source)

      assert_equal config.get(key), name
    ensure
      source.close
      source.unlink
    end

    def test_it_sets_a_value_for_nested_keys
      source = Tempfile.new
      config = Config.new(source)
      value = 'hello!'

      config.set(%w[this is a test], value)

      yaml = YAML.load_file(source)

      assert_equal yaml['this']['is']['a']['test'], value
    ensure
      source.close
      source.unlink
    end

    def test_get_returns_the_cached_config
      data = { this: { is: 'sparta' } }
      source = Tempfile.new
      source.write(data.to_yaml)
      source.rewind

      config = Config.new(source)

      assert_equal data, config.get
    ensure
      source.close
      source.unlink
    end

    def test_it_gets_a_value_from_nested_keys
      value = 'sparta'
      source = Tempfile.new
      source.write({ this: { is: value } }.to_yaml)
      source.rewind

      config = Config.new(source)

      assert_equal value, config.get(%i[this is])
    ensure
      source.close
      source.unlink
    end

    def test_it_returns_nil_if_keys_are_invalid
      source = Tempfile.new

      config = Config.new(source)

      assert_nil config.get(%i[this is])
    ensure
      source.close
      source.unlink
    end
  end
end
