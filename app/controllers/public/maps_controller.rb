require "set"

module Public
  class MapsController < ApplicationController
    include Frameable
    layout "public/frameable"

    def show
      @return_path = public_root_path
      @letters_data = Rails.cache.fetch("map_data") do
        # If cache is empty, run the job synchronously as a fallback
        Public::UpdateMapDataJob.perform_now
      end
    end
  end
end
