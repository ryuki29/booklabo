class RelationshipsController < ApplicationController
  def create
    current_user.relationships.create(
      followed_id: params[:followed_id].to_i
    )
  end

  def destroy
    relationship = current_user.relationships.find_by(
      followed_id: params[:id]
    )
    relationship.destroy
  end
end
