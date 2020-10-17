module V1
  class IpController < ApplicationController
    def log
      head 201
    end

    def seen
      render json: {}
    end

    def distinct
      render json: {}
    end
  end
end
