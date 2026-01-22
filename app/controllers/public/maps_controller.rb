require "set"

module Public
  class MapsController < ApplicationController
    include Frameable
    layout "public/frameable"

    def show
      @return_path = public_root_path
      @letters_data = Rails.cache.read("map_data")
      if @letters_data.nil?
        Public::UpdateMapDataJob.perform_later
        @letters_data = []
      end
    end
  end
end
