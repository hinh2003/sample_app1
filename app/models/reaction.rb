# frozen_string_literal: true

# this is model reaction
class Reaction < ApplicationRecord
  enum reaction_type: { Like: 0, Sad: 1, Angry: 2, Wow: 3 }
  belongs_to :user
  belongs_to :micropost, optional: true

  def self.get_reaction_type(user_id, micropost_id)
    reaction = Reaction.find_by(user_id: user_id, micropost_id: micropost_id)
    reaction&.reaction_type
  end

  def self.info_reactions(micropost_id)
    reactions = Reaction.where(micropost_id: micropost_id).order(created_at: :desc)
    total_reactions = reactions.count
    recent_users = reactions.order(created_at: :desc).limit(3).map { |reaction| reaction.user.name }
    { total_reactions: total_reactions, recent_users: recent_users }
  end
end
