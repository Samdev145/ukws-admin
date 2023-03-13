# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @products = Product.all.order(created_at: :desc)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      respond_to do |format|
        format.html { redirect_to @product }
        format.turbo_stream
      end
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)

      redirect_to @product
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_path }
      format.turbo_stream
    end
  end

  private

  def product_params
    params.require(:product).permit(
      :name, :record_type, :main_photo, :installed_photo, other_photos: []
    )
  end
end
