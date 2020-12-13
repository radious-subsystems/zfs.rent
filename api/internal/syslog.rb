require "#{__dir__}/pg"
require "colorize"

module Syslog
    def self.root(message, context={}, level=5, tag=nil)
        username = `whoami`
        hostname = `hostname`
        module_  = "internal_api"

        lut = {
            5 => :cyan,
            4 => :magenta,
            3 => :white,
            2 => :yellow,
            1 => :red,
            0 => :red
        }
        col = lut[level]
        $stderr.puts "[#{Time.now.to_s.colorize(col)}] " +
             "#{tag.yellow} : " +
             "\"#{message.bold}\" #{context}"

        $stderr.puts pg_exec(%{
            INSERT INTO sw_syslog
            (level, username, hostname, module , tag, message, context) VALUES
            ($1   , $2      , $3      , $4     , $5 , $6     ,      $7)
        },  [level, username, hostname, module_, tag, message, context.to_json]);
    end

    def self.debug  (message, context={}) Syslog::root(message, context, 5, caller[0][/`.*'/][1..-2]) end
    def self.verbose(message, context={}) Syslog::root(message, context, 4, caller[0][/`.*'/][1..-2]) end
    def self.info   (message, context={}) Syslog::root(message, context, 3, caller[0][/`.*'/][1..-2]) end
    def self.warn   (message, context={}) Syslog::root(message, context, 2, caller[0][/`.*'/][1..-2]) end
    def self.error  (message, context={}) Syslog::root(message, context, 1, caller[0][/`.*'/][1..-2]) end
    def self.fatal  (message, context={}) Syslog::root(message, context, 0, caller[0][/`.*'/][1..-2]) end

end
