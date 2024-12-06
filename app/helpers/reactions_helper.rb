# frozen_string_literal: true

# this is model helps
module ReactionsHelper
  def get_react(user_id, micropost_id)
    reaction_value = Reaction.get_reaction_type(user_id, micropost_id)
    reaction_icon(reaction_value)
  end

  def reaction_icon(reaction_name)
    reaction_icons = {
      'Like' => '👍',
      'Sad' => '😢',
      'Angry' => '😡',
      'Wow' => '😮'
    }
    reaction_icons[reaction_name] || 'Like'
  end

  def total_reactions(micropost)
    count = Reaction.info_reactions(micropost)
    count[:total_reactions]
  end

  def user_reactions(micropost)
    user_name = Reaction.info_reactions(micropost)
    user_name[:recent_users]
  end
end
