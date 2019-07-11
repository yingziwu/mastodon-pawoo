class PreserveOldLayoutForExistingUsers < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    # Assume that currently active users are already using the layout that they
    # want to use, therefore ensure that it is saved explicitly and not based
    # on the to-be-changed default

    # User.where(User.arel_table[:current_sign_in_at].gteq(1.month.ago)).find_each do |user|
    #   next if Setting.unscoped.where(thing_type: 'User', thing_id: user.id, var: 'advanced_layout').exists?
    #   user.settings.advanced_layout = true
    # end

    ::Web::Setting.preload(:user).find_each do |web_setting|
      if web_setting.data&.dig('pawoo', 'multiColumn')
        web_setting.user.settings.advanced_layout = true
      end
    end
  end

  def down
  end
end