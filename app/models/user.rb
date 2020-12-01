class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  after_commit :add_default_photo, on: [:create, :update]
  
  has_one_attached :photo
  has_many :midway_participants
  has_many :midways

  validates :username, uniqueness: :true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include PgSearch::Model
  pg_search_scope :search_by_username_and_first_name_and_last_name,
    against: [ :username, :first_name, :last_name ],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }


  def friends
   Friendship.where("user_id = ? or friend_id = ?", self.id, self.id)
   # friends_array = friendships.map{|friendship| friendship.friend if friendship.confirmed}
   # friends_array + inverse_friendships.map{|friendship| friendship.user if friendship.confirmed}
   # friends_array.compact
  end

  def not_friends_of_user
    friends_ids = (self.friends.map(&:user_id) + self.friends.map(&:friend_id)).uniq
    User.where.not(id: friends_ids)
  end

  # Users who have yet to confirme friend requests
   def pending_friends
     friendships.map{|friendship| friendship.friend if !friendship.confirmed}.compact
   end

   # Users who have requested to be friends
   def friend_requests
     inverse_friendships.map{|friendship| friendship.user if !friendship.confirmed}.compact
   end

   def confirm_friend(user)
     friendship = inverse_friendships.find{|friendship| friendship.user == user}
     friendship.confirmed = true
     friendship.save
   end

   def friend?(user)
     friends.include?(user)
   end

   private def add_default_photo

    unless photo.attached?
      self.photo.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: 'default.png' , content_type: "image/png")

    end
  end

end
