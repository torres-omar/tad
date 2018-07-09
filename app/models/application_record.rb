class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  @@month_names = {
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
  def self.month_names 
    @@month_names
  end
end
