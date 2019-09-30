# frozen_string_literal: true

class RelationshipsController < ApplicationController
  before_action :find_user, only: %i[followers following]

  def create
    current_user.active_relationships.create(
      followed_id: params[:followed_id].to_i
    )
  end

  def destroy
    relationship = current_user.active_relationships.find_by(
      followed_id: params[:id]
    )
    relationship.destroy
  end

  def followers
    @followers = @user.followers
  end

  def following
    @following = @user.following
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
