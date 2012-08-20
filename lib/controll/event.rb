module Controll
  class Event
    autoload :Helper,      'controll/event/helper'
    autoload :Matcher,     'controll/event/matcher'    

    class InvalidError < StandardError; end

    attr_reader :name, :type, :options

    def initialize name, *args
      raise ArgumentError, "Event must have a name identifier" if name.blank?
      @name     = name.to_sym
      @options  = args.extract_options! 
      @type     = (extract_type(args.first) || options[:type] || :notice).to_sym
      raise ArgumentError, "Invalid type: #{@type}" unless self.class.valid_type? @type 
      @options.delete(:type) if options[:type] == @type
    end
    
    def self.valid_types
      @valid_types ||= [:notice, :error, :warning, :success]
    end

    valid_types.each do |type|
      define_method :"#{type}?" do
        self.type == type.to_sym
      end
    end

    class << self
      attr_writer :valid_types

      def valid_type? type
        valid_types.map(&:to_sym).include? type.to_sym
      end

      def add_valid_types *types
        @valid_types += types if types.all? {|type| type.kind_of? Symbol}
      end
    end

    protected

    def extract_type arg
      arg.to_sym if type? arg
    end

    def type? arg
      arg.kind_of?(String) || arg.kind_of?(Symbol)
    end
  end
end