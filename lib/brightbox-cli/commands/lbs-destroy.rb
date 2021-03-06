module Brightbox
  desc 'Destroy load balancers'
  arg_name 'lb-id...'
  command [:destroy] do |c|

    c.action do |global_options, options, args|

      raise "You must specify the load balancers to destroy" if args.empty?

      lbs = LoadBalancer.find_or_call(args) do |id|
        raise "Couldn't find load balancer #{id}"
      end

      lbs.each do |lb|
        info "Destroying load balancer #{lb}"
        lb.destroy
      end
    end
  end
end
