class Micropost < ApplicationRecord
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }


	def self.from_users_followed_by(user)
		# 在数据库中进行子查询效率更高
		followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
		# followed_user_ids = user.followed_user_ids
		# where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
	end
end
