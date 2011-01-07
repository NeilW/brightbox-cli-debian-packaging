desc 'Create a load balancer'
arg_name 'srv-id...'
command [:create] do |c|

  c.desc "Friendly name of load balancer"
  c.flag [:n, :name]

  c.desc "Load balancer policy"
  c.default_value "least-connections"
  c.flag [:p, :policy]

  c.desc "Listeners. Format: in-port:out-port:type. Comma separate multiple listeners."
  c.default_value "80:80:http,443:443:tcp"
  c.flag [:l, :listeners]

  c.desc "Healthcheck port"
  c.default_value "80"
  c.flag [:k, "hc-port"]

  c.desc "Healthcheck type"
  c.default_value "http"
  c.flag [:y, "hc-type"]

  c.desc "Healthcheck timeout"
  c.default_value "5000"
  c.flag [:t, "hc-timeout"]

  c.desc "Healthcheck request. When the type is 'http' this is the url to request."
  c.default_value "/"
  c.flag [:s, "hc-request"]

  c.desc "Healthcheck interval"
  c.default_value "5000"
  c.flag [:e, "hc-interval"]

  c.desc "Healthcheck threshold up. Time a healthcheck has to succeed to be considered up."
  c.default_value "3"
  c.flag [:u, "hc-up"]

  c.desc "Healthcheck threshold down. Time a healthcheck has to fail to be considered down."
  c.default_value "3"
  c.flag [:d, "hc-down"]

  c.action do |global_options, options, args|

    raise "You must specify which servers to balance connections to" if args.empty?

    listeners = options[:l].split(",").collect do |l|
      inport, output, protocol = l.split ":"
      { :in => inport, :out => output, :protocol => protocol }
    end

    hc_arg_lookup = { :k => :port, :y => :type, :t => :timeout, :s =>
      :request, :e => :interval, :u => :threshold_up, :d =>
      :threshold_down }

    healthcheck = {}

    options.keys.each do |k|
      if options[k] and hc_arg_lookup[k]
        healthcheck[hc_arg_lookup[k]] = options[k]
      end
    end

    nodes = args.collect { |i| { :node => i } }

    msg = "Creating a new load balancer"
    info msg
    lb = LoadBalancer.create(:policy => options[:policy],
                        :name => options[:n],
                        :healthcheck => healthcheck,
                        :listeners => listeners,
                        :nodes => nodes)
    render_table([lb], global_options)
  end
end