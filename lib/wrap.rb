
module MPT
  class Wrap
    @@wrap_variables = {}
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
          res = temp[wrap_name] unless temp[wrap_name].blank?
        end

        if res.nil? && !default.nil?
          res = default
          if default.instance_of?( Proc )
            res = default.call 
          end
        end

        res
      end
    end
  end
end

class Class
  class << self
    def wrap_it(target, options = { :using => :run, :scope => :before })
      return if options[:by].nil?
      
      targets = target
      targets = [target] unless target.instanceof?( Array )
      targets.each do |tgt|
        wrap_it_single(tgt, options)
      end      
    end
    
    def wrap_with(target, options = {})
      return if options.blank?
      
      targets = target
      targets = [target] unless target.instanceof?( Array )
      targets.each do |tgt|
        wrap_with_single(tgt, options)
      end
    end
    
    private
    def wrap_it_single(target, options)
      
    end
    
    def wrap_with_single(target, options)
      code = <<-EOC
        def #{target.to_s}_with_wrap_options(*args)
          MPT::Wrap.with #{options.inspect} do
            #{target.to_s}_without_wrap_options(*args)
          end
        end
        
        alias_method :#{target.to_s}, :wrap_options
      EOC
      
      self.class_eval(code, __FILE__, __LINE__)
    end
  end
end

class Class
	def wrappable(accessor_name, wrap_name)
		code = <<-EOS
		  def #{accessor_name.to_s}_with_wrap_support
        MPT::Wrap.get("#{wrap_name}", Proc.new { self.send :"#{accessor_name.to_s}_without_wrap_support" })
		  end

		  alias_method_chain :#{accessor_name.to_s}, :wrap_support
		EOS
		
		class_eval(code, __FILE__, __LINE__)
	end
end
