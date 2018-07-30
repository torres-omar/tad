module Callable
    extend ActiveSupport::Concern 

    # create a class method called call
    # the method create a new instance of the class
    # and calls a 'call' instance method defined on the class
    class_methods do 
        def call(*args)
            new(*args).call
        end
    end
end
