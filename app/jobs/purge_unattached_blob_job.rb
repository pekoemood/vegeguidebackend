class PurgeUnattachedBlobJob < ApplicationJob
  queue_as :default

  def perform
    ActiveStorage::Blob.unattached.find_each do |blob|
      blob.purge
    end
  end
end
