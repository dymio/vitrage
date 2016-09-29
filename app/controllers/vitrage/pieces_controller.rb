module Vitrage
  class PiecesController < ApplicationController
    before_action :find_vitrage_piece, only: [:show, :edit, :update]

    def show
      respond_to do |format|
        format.html { render layout: false }
      end
    end

    def new
      piece_class = params[:kind]
      unless piece_class &&
             VitrageOwnersPiecesSlot::PIECE_CLASSES_STRINGS.include?(piece_class)
        piece_class = VitrageOwnersPiecesSlot::PIECE_CLASSES_STRINGS.first
      end
      @piece = VitragePieces.const_get(piece_class).new

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
      error_state = nil

      # check existance of params
      unless params[:kind] &&
             VitrageOwnersPiecesSlot::PIECE_CLASSES_STRINGS.include?(params[:kind]) &&
             params[:owner_type] &&
             params[:owner_id]
        error_state = { descr: "Necessary parameters didn't exist error" }
      end

      # get the owner of vitrage
      if error_state.nil?
        @owner = nil
        begin
          @owner = Object.const_get(params[:owner_type]).find params[:owner_id]
        rescue Exception => e
          error_state = { descr: "Owner find error" }
        end
      end

      # create piece
      if error_state.nil?
        @piece = VitragePieces.const_get(params[:kind]).new
        @piece.assign_attributes vitrage_piece_params
        unless @piece.save
          error_state = {
            descr: "Piece save error",
            piece: @piece.class.name.demodulize.underscore,
            errors: @piece.errors
          }
        end
      end

      # create vitrage slot
      if error_state.nil?
        @slot = VitrageOwnersPiecesSlot.new owner: @owner, piece: @piece
        unless @slot.save
          error_state = { descr: "Slot save error" }
          @piece.destroy
        end
      end

      if error_state
        respond_to do |format|
          format.html { render json: error_state.merge({ status: 'error' }),
                        status: :unprocessable_entity }
        end
      else
        respond_to do |format|
          format.html { render layout: false }
          format.js # for remotipart gem correct work (ajax multipart form)
        end
        # render layout: false
      end
    end

    def update
      if @piece.update(vitrage_piece_params)
        respond_to do |format|
          format.html { render text: "" }
          format.js { render text: "" }
        end
      else
        error_state = {
          status: 'error',
          descr: "Piece save error",
          piece: @piece.class.name.demodulize.underscore,
          errors: @piece.errors
        }
        respond_to do |format|
          format.html { render json: error_state, status: :unprocessable_entity }
          format.js { render json: error_state, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @slot = VitrageOwnersPiecesSlot.find params[:id]
      @slot.destroy

      respond_to do |format|
        format.html { render text: "" }
      end
    end

    def reorder
      moved_slot = VitrageOwnersPiecesSlot.find params[:id]
      wrong_params = false

      if params[:beforeid].present?
        if params[:beforeid] == "end"
          max_ordn = moved_slot.owner.vitrage_slots.maximum(:ordn)
          moved_slot.update_attributes ordn: max_ordn ? max_ordn + 1 : 1
        else

          slot_after_moved = VitrageOwnersPiecesSlot.find_by_id params[:beforeid]
          if slot_after_moved.present? && slot_after_moved.owner == moved_slot.owner
            ordn_for_moved = slot_after_moved.ordn
            all_slots_after_moved = moved_slot.owner.vitrage_slots.
                                                     where("vitrage_owners_pieces_slots.ordn >= ?", ordn_for_moved).
                                                     where.not(id: moved_slot.id).
                                                     order(ordn: :asc)
            all_slots_after_moved.each do |slot|
              slot.update_attributes ordn: slot.ordn + 1
            end
            moved_slot.update_attributes ordn: ordn_for_moved

          else
            wrong_params = true
          end
        end
      else
        wrong_params = true
      end

      if wrong_params
        render text: "wrong params", status: :unprocessable_entity
      else
        render text: "ok"
      end
    end

    def restore_order
      owners = VitrageOwnersPiecesSlot.all.collect { |vp| vp.owner }.uniq
      owners.each do |owner|
        owner.vitrage_slots.each_with_index do |slot, indx|
          slot.update_attributes ordn: indx + 1
        end
      end
      render text: "ok"
    end

    private

    def find_vitrage_piece
      @slot = VitrageOwnersPiecesSlot.find params[:id]
      @piece = @slot.piece
    end

    def vitrage_piece_params
      params.require(@piece.class.name.underscore.gsub('/', '_').to_sym).
             permit @piece.params_for_permit
    end
  end
end
