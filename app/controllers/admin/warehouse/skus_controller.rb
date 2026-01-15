module Admin
  module Warehouse
    class SKUsController < Admin::ApplicationController
      def sync_to_zenventory
        requested_resource.sync_to_zenventory!
        redirect_to [:admin, requested_resource], notice: "Synced to Zenventory"
      rescue Zenventory::ZenventoryError => e
        redirect_to [:admin, requested_resource], alert: "Zenventory sync failed: #{e.message}"
      end
    end
  end
end
