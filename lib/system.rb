
class Object
  def instance_eval_with_args(proc, *args, &block)
    mod = @mpt_injection_module ||= Module.new
    self.extend mod
    mod.send :define_method, :mpt_instance_with_args_handler, proc
    self.mpt_instance_with_args_handler( *args, &block )
    mod.send :undef_method, :mpt_instance_with_args_handler
  end
end
