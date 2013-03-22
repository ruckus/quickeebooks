module Quickeebooks
  module Shared
    module Service
      class Filter

        DATE_FORMAT = '%Y-%m-%d'
        DATE_TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%Z'

        attr_reader :type
        attr_accessor :field, :value

        # For Date/Time filtering
        attr_accessor :before, :after

        # For number comparisons
        attr_accessor :gt, :lt, :eq

        def initialize(type, *args)
          @type = type
          if args.first.is_a?(Hash)
            args.first.each_pair do |key, value|
              instance_variable_set("@#{key}", value)
            end
          end
        end

        def to_s
          case @type.to_sym
          when :date, :datetime
            date_time_to_s
          when :text
            text_to_s
          when :boolean
            boolean_to_s
          when :number
            number_to_s
          else
            raise ArgumentError, "Don't know how to generate a Filter for type #{@type}"
          end
        end

        def to_xml
          case @type.to_sym
          when :text
            text_to_xml
          when :boolean
            boolean_to_xml
          when :datetime
            datetime_to_xml
          else
            raise ArgumentError, "Don't know how to generate a Filter for type #{@type}"
          end
        end

        private

        def number_to_s
          clauses = []
          if @eq
            clauses << "#{@field} :EQUALS: #{@eq}"
          end
          if @gt
            clauses << "#{@field} :GreaterThan: #{@gt}"
          end
          if @lt
            clauses << "#{@field} :LessThan: #{@lt}"
          end
          clauses.join(" :AND: ")
        end

        def date_time_to_s
          clauses = []
          if @before
            raise ':before is not a valid DateTime/Time object' unless (@before.is_a?(Time) || @before.is_a?(DateTime))
            clauses << "#{@field} :BEFORE: #{formatted_time(@before)}"
          end
          if @after
            raise ':after is not a valid DateTime/Time object' unless (@after.is_a?(Time) || @after.is_a?(DateTime))
            clauses << "#{@field} :AFTER: #{formatted_time(@after)}"
          end

          if @before.nil? && @after.nil?
            clauses << "#{@field} :EQUALS: #{formatted_time(@value)}"
          end

          clauses.join(" :AND: ")
        end

        def text_to_s
          "#{@field} :EQUALS: #{@value}"
        end

        def text_to_xml
          "<#{@field}>#{CGI::escapeHTML(@value.to_s)}</#{@field}>"
        end

        def boolean_to_s
          "#{@field} :EQUALS: #{@value}"
        end

        def boolean_to_xml
          "<#{@field}>#{CGI::escapeHTML(@value.to_s)}</#{@field}>"
        end

        def datetime_to_xml
          "<#{@field}>#{CGI::escapeHTML(@value.xmlschema)}</#{@field}>"
        end

        def formatted_time(time)
          if time.is_a?(Date)
            time.strftime(DATE_FORMAT)
          elsif time.respond_to?(:strftime) # catch any other Time-like object
            time.strftime(DATE_TIME_FORMAT)
          end
        end
      end
    end
  end
end
