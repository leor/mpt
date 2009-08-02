
module MPT
  class Wrap  
    @@wrap_variables = {}
    @@registry = {}
    class << self
      def with(var ={}, &block)
        thread_id = Thread.current.object_id
        @@wrap_variables[thread_id]||={}
        temp = @@wrap_variables[thread_id].dup
        @@wrap_variables[thread_id].merge!(var)
        yield
        @@wrap_variables[thread_id] = temp
      end
      
      def get(wrap_name, default = nil)
        temp = @@wrap_variables[Thread.current.object_id]
        res = nil


        if !temp.blank?
          res = temp[wrap_name] unless temp[wrap_name].nil?
        end

        if res.nil? && !default.nil?
          res = default
          if default.instance_of?( Proc )
            res = default.call 
          end
        end

        res
      end
      
      def register(value)
        @@uuid_generator ||= UUID.new
        key = @@uuid_generator.generate(:urn).to_s
        @@registry[key] = value
        key
      end
      
      def get_from_registry(key)
        @@registry[key]
      end
    end
    
    class Blank
      def self.run(*args)
      end
    end
  end
end

class Class
  def wrap_it(target, options = { :using => :run, :scope => :before }, &block)
    return if options[:by].nil? && block.nil?
    
    targets = target
    targets = [target] unless target.instance_of?( Array )
    targets.each do |tgt|
      wrap_it_single(tgt, options, &block)
    end      
  end
  
  def wrap_with(target, options = {})
    return if options.blank?
    
    targets = target
    targets = [target] unless target.instance_of?( Array )
    targets.each do |tgt|
      wrap_with_single(tgt, options)
    end
  end
  
  private
  def wrap_it_single(target, options, &block)
    by_name = options[:by]
    old_method_name = "#{target.to_s}_without_wrap_it"
    
    instance_to_call_code = "self"
    unless by_name == :self 
      instance_to_call_code = "MPT::Wrap.get( #{by_name.inspect}, MPT::Wrap::Blank )"
    end
    
    if by_name.nil? && !block.nil? 
      block_key = MPT::Wrap.register(block)
      instance_to_call_code = "self.instance_eval( &MPT::Wrap.get_from_registry(#{block_key.inspect}) )"
    end
    
    scope_call_code = "target_instance.#{options[:using]}(*args, &block); #{old_method_name}(*args, &block)"
    
    if options[:scope] == :after
      scope_call_code = "#{old_method_name}(*args, &block); target_instance.#{options[:using]}(*args, &block)"
    end
    
    if options[:scope] == :around
      scope_call_code = "target_instance.#{options[:using]}(*args) { #{old_method_name}(*args, &block) }"
    end
    
    code_to_eval = <<-EOC
      def #{target.to_s}_with_wrap_it(*args, &block)
        target_instance = #{instance_to_call_code}
        #{scope_call_code}
      end
      
      alias_method_chain #{target.to_sym.inspect}, :wrap_it
    EOC
    
    self.class_eval(code_to_eval, __FILE__, __LINE__)
  end
  
  def wrap_with_single(target, options)
    key = MPT::Wrap.register(options.dup)
    code = <<-EOC
      def #{target.to_s}_with_wrap_options(*args)
        MPT::Wrap.with MPT::Wrap.get_from_registry(#{key.inspect}) do
          #{target.to_s}_without_wrap_options(*args)
        end
      end
      
      alias_method_chain #{target.to_sym.inspect}, :wrap_options
    EOC
    
    self.class_eval(code, __FILE__, __LINE__)
  end
end

class Class
	def wrappable(accessor_name, wrap_name)
	  acc_name = accessor_name.to_s
		code = <<-EOS
		  def #{acc_name}_with_wrap_support
        MPT::Wrap.get( "#{wrap_name}", 
          Proc.new do 
            if self.respond_to?( :"#{acc_name}_without_wrap_support" )
              self.send :"#{acc_name}_without_wrap_support"
            end  
          end)
		  end

      if self.public_instance_methods.include?( "#{acc_name}" )
		    alias_method_chain :"#{acc_name}", :wrap_support
		  else
		    alias :"#{acc_name}" :"#{acc_name}_with_wrap_support"
	    end
		EOS
		
		class_eval(code, __FILE__, __LINE__)
	end
	
	alias :wrapable :wrappable # "wrappable" will be removed in future versions
end
