
class Object
  def instance_eval_with_args(*args, &proc)
    mod = @mpt_injection_module ||= Module.new
    self.extend mod
    mod.send :define_method, :mpt_instance_with_args_handler, proc
    self.mpt_instance_with_args_handler( *args )
    mod.send :undef_method, :mpt_instance_with_args_handler
  end
end

class Class
  def cache_method(method_name, cache_name = nil)
    cache_attr_name = cache_name
    cache_attr_name = "#{method_name.to_s}_cache" if cache_name.blank?

    class_eval(<<-EOS, __FILE__, __LINE__)
      def #{method_name.to_s}_with_cache_support(*args)
        @#{cache_attr_name} ||= {}
        @#{cache_attr_name}[args] ||= #{method_name.to_s}_without_cache_support( *args )
      end

      alias_method_chain :#{method_name.to_s}, :cache_support
    EOS

  end
end
