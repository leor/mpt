
module WrapMethodsExperiment
  include ::MPT
  
  class TargetORM
    def initialize(name = 'default')
      @name = 'default'
    end
    
    def execute(sql)
      puts "#{@name} execute '#{sql}'"
    end
    
    def query(sql)
      puts "#{@name} query '#{sql}'"
    end
    
    def transaction
      puts "TRANSACTION BEGIN"
      yield
      puts "TRANSACTION COMMIT"
    end
  end
  
  class TargetController
    attr_reader :orm
    wrappable :orm, '/system/orm'
  
    def initializer(system_orm)
      @orm = system_orm
    end
    
    def process
      orm.execute( "ControllerSQL" )
    end
  end
  
  class TargetDispatcher
    def initializer
      @orm = TargetORM.new
    end
    
    def process
      @orm.query("dispatcher-sql")
      
      controller = TargetController.new(@orm)
      controller.process
    end
  end
  
  class MonkeyPatch
    def run(sql)
      puts "Patcher run: '#{sql}'"
    end
  end
  
  experiment "Wrap methods experiment" do
    TargetORM.wrap_it [:execute, :query], :by => '/patches/monkey-patch', :using => :run, :scope => :before
    
    orm = TargetORM.new
    orm.execute "First SQL"
    
    patch = MonkeyPatch.new
    Wrap.with '/patches/mokey-patch' => patch do
      orm.execute "Second SQL"
    end
    
  end
  
  experiment "Wrap by around methods" do
    TargetDispatcher.wrap_it :process, :by => :self, :using => :transaction, :scope => :around
    TargetController.wrap_with :process, '/system/orm' => TargetORM.new('custom')
  
    dispatcher = TargetDispatcher.new
    
    dispatcher.process
  end
  
end
