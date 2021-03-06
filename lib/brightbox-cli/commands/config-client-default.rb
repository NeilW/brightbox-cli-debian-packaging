module Brightbox
  desc 'Set the default api client in the config'
  arg_name 'alias'
  command [:client_default] do |c|

    c.action do |global_options, options, args|

      info "Using config file #{CONFIG.config_filename}"
      calias = args.shift

      if calias.nil?
        raise "You must specify the api alias you want to set as the default"
      end

      client_config = CONFIG.clients.detect{|c| CONFIG[c]['alias'] == calias}
      if client_config.nil?
        raise "An api client with the alias #{calias} does not exist in the config"
      end

      info "Setting #{calias} as default api client"
      CONFIG['core']['default_client'] = client_config
      CONFIG.save!

    end
  end
end
