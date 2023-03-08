# frozen_string_literal: true

class TranslationsController < ApplicationController
  def index
    @crm_translations = Translation.from_crm_to_accounts
    @store_translations = Translation.from_store_to_accounts
  end

  def new
    @translation = Translation.new
  end

  def edit
    @translation = Translation.find(params[:id])
  end

  def create
    @translation = Translation.new(translation_params)

    if @translation.save
      respond_to do |format|
        format.html { redirect_to @translation }
        format.turbo_stream
      end
    else
      render :new
    end
  end

  def update
    @translation = Translation.find(params[:id])

    @translation.update(translation_params)

    respond_to do |format|
      format.html { redirect_to translations_path }
      format.turbo_stream
    end
  end

  def destroy
    @translation = Translation.find(params[:id])
    @translation.destroy

    respond_to do |format|
      format.html { redirect_to translations_path }
      format.turbo_stream
    end
  end

  private

  def translation_params
    params.require(:translation).permit(
      :translation_type, :name, :translated_as
    )
  end
end
