class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    MONTH_NAMES = {
        1 => "Jan", 
        2 => "Feb", 
        3 => "Mar", 
        4 => "Apr", 
        5 => "May", 
        6 => "Jun", 
        7 => "Jul", 
        8 => "Aug", 
        9 => "Sep", 
        10 => "Oct", 
        11 => "Nov", 
        12 => "Dec"
    }

    # filters out CX positions as well as dummy jobs
    # dummy job id = 770944
    FILTERED_JOB_IDS = [571948, 770944]
    # FILTERED_JOB_IDS = [571948]

    def self.month_names 
      MONTH_NAMES
    end
end
