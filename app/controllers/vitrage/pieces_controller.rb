module Vitrage
  class PiecesController < ApplicationController
    before_action :authenticate_admin_user! # TODO remove to child controller
    before_action :find_vitrage_piece, only: [:show, :edit, :update]

    def show
      respond_to do |format|
        format.html { render layout: false }
      end
    end
   
    def new
      item_type = params[:kind]
      unless item_type && VitragePiece::PIECE_KINDS.include?(item_type)
        item_type = VitragePiece::PIECE_KINDS.first
      end
      @item = VitragePieces.const_get(item_type).new
      respond_to do |format|
        format.html { render layout: false }
      end
    end
   
    def edit
      respond_to do |format|
        format.html { render layout: false }
      end
    end
   
    def create
      wrong_params_here = false

      # check existance of params
      unless params[:kind] && VitragePiece::PIECE_KINDS.include?(params[:kind]) && params[:owner_type] && params[:owner_id]
        wrong_params_here = true
      end

      # get the owner of content block
      unless wrong_params_here
        @owner = nil
        begin
          @owner = Object.const_get(params[:owner_type]).find params[:owner_id]
        rescue Exception => e
          wrong_params_here = true
        end
      end

      # create item
      unless wrong_params_here
        @item = VitragePieces.const_get(params[:kind]).new
        @item.assign_attributes vitrage_piece_item_params
        wrong_params_here = true unless @item.save
      end

      # create content block
      unless wrong_params_here
        @vitrage_piece = VitragePiece.new owner: @owner, item: @item
        unless @vitrage_piece.save
          wrong_params_here = true
          @item.destroy
        end
      end

      if wrong_params_here
        respond_to do |format|
          format.html { render text: "error", status: :unprocessable_entity }
        end
      else
        # respond_to do |format|
        #   format.html { render layout: false }
        # end
        render layout: false
      end
    end
   
    def update
      @vitrage_piece.item.update vitrage_piece_item_params

      respond_to do |format|
        format.html { render action: "show", layout: false }
      end
    end
   
    def destroy
      @vitrage_piece = VitragePiece.find params[:id]
      @vitrage_piece.destroy

      respond_to do |format|
        format.html { render text: "" }
      end
    end

    private

    def find_vitrage_piece
      @vitrage_piece = VitragePiece.find params[:id]
      @item = @vitrage_piece.item
    end

    def vitrage_piece_item_params
      params.require(@item.class.name.underscore.gsub('/', '_').to_sym).permit @item.params_for_permit
    end
  end
end
