
module MPT
  class EventContainer
    attr_accessor :event_object

    def initialize( val = nil )
      self.event_object = val.dup unless val.nil?
    end
    
  end

  class FilterChain < Array
    def reorganize
      index = 0
      while index < self.size
        filter = self[index]
        filter_opts = filter[:options]
        unless filter_opts[:after].nil?
          for i in index..self.size-1
            fo = self[i][:options]
            unless fo[:as].nil?
              if fo[:as] == filter_opts[:after]
                new_chain = []
                new_chain += self[0..index-1] if index > 0
                new_chain += [self[i]]
                new_chain += self[index..i-1]
                new_chain += self[i+1..self.size-1]
                self.replace new_chain 
                index = 0
                break
              end # if :as matched with :after
            end	# unless :as is nil				
          end # for next items
        end # unless :after is nil
        index += 1
      end # while index < list size
    end # def reorganize
  end # filter chain class

  class Event
    @@mpt_subscribers = {}
    
    class << self
      def subscribe(event_name, options = {}, &block)
        channel = @@mpt_subscribers[event_name] ||= MPT::FilterChain.new
        channel << { :options => options, :proc => block }
        channel.reorganize
      end

      def trigger_with_object(event_name, object, *args)
        container = MPT::EventContainer.new(object)
        channel = @@mpt_subscribers[event_name]
        if !channel.nil? && channel.size > 0

          channel.each do |subscriber|
            container.instance_eval_with_args( *args, &subscriber[:proc] )
          end
        end

        container.event_object
      end

      def trigger(event_name, *args)
        trigger_with_object(event_name, nil, *args)
      end
      
      def clear_event_chain(event_name)
        @@mpt_subscribers.delete(event_name)
      end
      
      def clear_owner_subscribers(owner)
        @@mpt_subscribers.each_pair do |event_name, subscribers|
          @@mpt_subscribers[event_name] = subscribers.select { |s| owner != s[:options][:owner]  }
        end
      end
    end # end of static section
  end # end of class Event
  
end
