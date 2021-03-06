module Brightbox
  desc 'Remove nodes from a load balancer'
  arg_name 'lb-id node-id...'
  command [:remove_nodes] do |c|

    c.action do |global_options, options, args|

      raise "You must specify the load balancer and the node ids to remove" if args.size < 2

      lb = LoadBalancer.find(args.shift)

      # We don't want to check servers exist as you can remove deleted
      # servers from a load balancer.
      nodes = args.collect { |a| Server.new(a) }

      info "Removing #{nodes.size} nodes from load balancer #{lb.id}"
      lb.remove_nodes nodes
      lb.reload
      render_table([lb], global_options)
    end
  end
end
