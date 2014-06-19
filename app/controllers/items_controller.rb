class ItemsController < ApplicationController
	before_action :set_item, only: [:show, :update, :destroy]
	respond_to :json
	include ItemsHelper

	def index
		respond_with Item.all
	end	

	def create
		respond_with Item.create(item_params)
	end
	private
	def set_item
		@item = Item.find(params[:id])
	end	
	def item_params
		params.require(:item).permit(:name, :description, :images, :email, :lat, :long )
	end	
end
