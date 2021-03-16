class OembedController < ApplicationController
  require 'oembed'
  def create
    begin
      OEmbed::Providers.register_all
      url = params[:oembed][:body]
      response = OEmbed::Providers.get(url)
    rescue OEmbed::NotFound
      head 422 and return
    end

    if @oembed = ActionText::Oembed.create(url: url, raw_info: response.to_json)
      render :show, status: :ok
    else
      render json: @oembed.errors, status: :unprocessable_entity
    end
  end
 
end
