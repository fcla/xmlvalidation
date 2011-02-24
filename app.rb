require 'bundler/setup'

require 'sinatra'
require 'haml'

module XmlValidation

  include Java

  class Checker
    include org.xml.sax.ErrorHandler

    def initialize
      @es = []
      @fs = []
      @ws = []
    end

    def error e
      @es << e
    end

    def fatalError e
      @fs << e
    end

    def warning e
      @ws << e
    end

    def results
      @es.map { |e| convert_exception :error, e } +
        @fs.map { |e| convert_exception :fatal, e } +
        @ws.map { |e| convert_exception :warning, e }
    end

    private

    def convert_exception level, e

      {
        :level => level,
        :message => e.getMessage,
        :line => e.getLineNumber,
        :column => e.getColumnNumber,
        :system_id => e.getSystemId,
        :public_id => e.getPublicId
      }

    end

  end

  # validate a file returning a list of errors
  # this is done in a separate proc because this creates java threads that cause the ruby instance to crash
  def validate_xml f

    # make a document builder
    factory = javax.xml.parsers.DocumentBuilderFactory.newInstance
    factory.setNamespaceAware true
    factory.setAttribute "http://xml.org/sax/features/validation", true
    factory.setAttribute "http://apache.org/xml/features/validation/schema", true
    factory.setAttribute "http://apache.org/xml/features/validation/schema-full-checking", true
    factory.setAttribute "http://apache.org/xml/features/nonvalidating/load-external-dtd", true
    builder = factory.newDocumentBuilder

    # parse the xml to get any errors
    checker = Checker.new
    builder.setErrorHandler checker
    builder.parse f
    checker.results
  end
  module_function :validate_xml
end

helpers do

  def issue_table name, is
    haml :issues, :layout => false, :locals => { :issues => is, :name => name }
  end

end

get '/' do
  haml :index
end

post '/' do
  @path = params[:xml][:tempfile].path
  @filename = params[:xml][:filename]
  @results = XmlValidation.validate_xml @path
  @warnings = @results.select { |r| r[:level] == :warning }
  @errors = @results.select { |r| r[:level] == :error }
  @fatals = @results.select { |r| r[:level] == :fatal }
  haml :results
end
