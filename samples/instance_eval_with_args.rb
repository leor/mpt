module InstanceEvalWithArgumentsExperiment
  include ::MPT
  
  experiment "Instaince eval with arguments experiment" do
    proc = Proc.new do |argument|
      puts "this proc called in instance context of <##{self.object_id.to_s}@#{self.class.name}> \n\twith argument value: #{argument}"
    end
    
    container = "Some string for example"
    container.instance_eval_with_args "ArgumentExperimentValue", &proc
  end
  
end