class Device < ActiveRecord::Base
  validates :physical_device_id, uniqueness: true

end
