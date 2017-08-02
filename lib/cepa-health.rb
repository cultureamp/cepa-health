# encoding: utf-8
# Copyright © 2013 Jon Williams. See LICENSE.txt for details.

require "cepa-health/engine"

module CepaHealth
  attr_accessor :success

  # Container that holds the result of the probe execution
  class Result
    attr_reader :records

    def execute(block)
      v = instance_exec(&block)
      Array === v ? record(*v) : record("Probe", v, v ? "Success" : "Failed")
    rescue Exception => e
      $stderr.puts "#{e.class}: #{e.message}\n#{e.backtrace * "\n"}"
      record("Probe Exception", false, "#{e.class}: #{e.message}")
    end

    def initialize
      @records = []
      @success = true
    end

    def record(name, status, comment = nil)
      @success = @success && !!status
      @records << [name.to_s, !!status, (comment || "").to_s]
    end

    def success?
      @success
    end

  end

  class << self
    attr_accessor :key
    attr_reader :probes

    def clear_probes!
      @probes = {}
    end

    # Executes the probes.
    # @param [ Array<String> ] filters to the given probes, based on name
    # If no filters are specified, all probes are resulted.
    def execute(only:, except:)
      only = only.nil? ? [] : parse_filters(only)
      except = except.nil? ? [] : parse_filters(except)
      result = CepaHealth::Result.new
      selected = only.empty? ? probes : probes.select { |k,v| only.include?(k) }
      selected = selected.reject { |k,v| except.include?(k) }
      selected.values.flatten(1).each { |v| result.execute(v) }
      result
    end

    def parse_filters(filters)
      filters.split(",").map { |v| v.strip }
    end

    # Loads an individual probe
    def load_probe(name)
      dir = File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'probes'))
      Dir[File.join(dir, name)].each { |v| require(v) }
    end

    # Scans the probes directory for Ruby files.
    def load_probes
      dir = File.expand_path(File.join(File.dirname(File.expand_path(__FILE__)), '..', 'probes'))
      Dir[File.join(dir, "**/*.rb")].each { |v| require(v) }
    end

    # Registers the given block as a probe. An optional level can be supplied,
    # which can be used as a filter.
    def register(name, &block)
      probes[name.to_s] = block
      self
    end
  end

  @probes = {}
  @key = nil

end

require "cepa-health/version"
