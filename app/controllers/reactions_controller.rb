# frozen_string_literal: true

# this is controller reaction
class ReactionsController < ApplicationController
  def create
    microposts = Micropost.find_by(id: reaction_params[:micropost_id])
    redirect_to root_path and return if microposts.nil?

    build_reaction
    @reaction.save
    render json: { success: true, message: 'Reaction saved successfully.'},
           status: :ok
  end

  def destroy
    find_reaction_by_user
    if find_reaction_by_user
      @reaction.destroy
      redirect_to request.referer
    else
      flash[:info] = ' Micropost not found.'
      redirect_to root_path
    end
  end

  private

  def reaction_params
    params.permit(:reaction_type, :micropost_id)
  end

  def build_reaction
    @reaction = current_user.reactions.find_or_initialize_by(micropost_id: reaction_params[:micropost_id])
    @reaction.reaction_type = reaction_params[:reaction_type]
  end

  def find_reaction_by_user
    @reaction = current_user.reactions.find_by(micropost_id: reaction_params[:micropost_id])
  end
end
