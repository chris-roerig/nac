# frozen_string_literal: true

module Nac
  # The main configuration manager class
  class Config
    attr_reader :template, :source

    def initialize(source, options = {})
      @source     = source
      @template   = (options[:template] || {}).to_yaml

      options[:init!] ? init! : init
      cache
    end

    def init!
      FileUtils.mkdir_p(File.dirname(@source))

      File.open(@source, 'w+') do |file|
        file.write(@template)
      end
    end

    def get(keys = nil)
      return @cache unless keys

      val = @cache

      [keys].flatten.each do |key|
        val = val[key]
      end

      val
    rescue NoMethodError
      nil
    end

    def set(keys, value)
      @cache.merge!(bury(keys, value))

      File.write(@source, @cache.to_yaml)

      cache!
    end

    private

    def init
      return true if File.exist?(@source)

      init!
    end

    def bury(keys, value)
      hkeys = [keys].flatten.map { |k| { k => nil } }

      hkeys.count.times do |i|
        val = hkeys[i + 1] || value
        hkeys[i][hkeys[i].keys[0]] = val
      end

      hkeys.shift
    end

    def cache!
      @cache = nil
      cache
    end

    def cache
      @cache ||= YAML.load_file(@source) || {}
    end
  end
end
