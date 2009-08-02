module UnorderedSubscribersExperiment
  include ::MPT
  
  class Stub
    def some_method(argument)
      puts "Subscribe class instance for event: #{argument}"
    end
    
    subscribe :some_method, :for => "/some/method"
  end
  
  experiment "Unordered subscribers with void event object" do
    Event.subscribe '/system/special-channel' do |parameter|
      self.event_object = parameter
    end

    Event.subscribe '/system/special-channel' do |parameter|
      self.event_object = "#{event_object} AND same shit"
    end

    result = Event.trigger '/system/special-channel', "XXX"
    puts "Result is: #{result}"
  end
  
  experiment "Subscribed instance methods" do
    stub_instance = Stub.new
    Event.trigger '/some/method', "[SUCCESS]"
  end
end
