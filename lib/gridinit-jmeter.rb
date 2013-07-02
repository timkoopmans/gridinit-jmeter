require 'nokogiri'
require 'rest_client'
require 'json'
require 'cgi'
require 'open3'

require 'gridinit-jmeter/version'
require 'gridinit-jmeter/helpers/helper'
require 'gridinit-jmeter/helpers/parser'
require 'gridinit-jmeter/helpers/fallback_content_proxy'
require 'gridinit-jmeter/helpers/logger-colors'
require 'gridinit-jmeter/helpers/strip-heredoc'
require 'gridinit-jmeter/helpers/user-agents'

lib = File.dirname(File.absolute_path(__FILE__))
Dir.glob(lib + '/gridinit-jmeter/dsl/*', &method(:require))
Dir.glob(lib + '/gridinit-jmeter/plugins/*', &method(:require))
require 'gridinit-jmeter/dsl'
