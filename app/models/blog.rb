class Blog < ActiveRecord::Base
  default_scope -> { order('created_at DESC') }
  validates :title, presence: true, length: {minimum: 6}
  validates :content, presence: true, length: {minimum: 20}


  # Avatar attached
  has_attached_file :picture, :styles => {:medium => "180x100>", :thumb => "90x50>", :large => "500x500>", :normal => "250x250>"}, :default_url => "/images/:style/missing.png", :storage => :s3, :bucket => "teleport_site",
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials }
  # Amazon s3
  def s3_credentials
    {:bucket => "teleport_site", :access_key_id => "AKIAIEZ3VHOH3FJJXJPQ", :secret_access_key => "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"}
  end

  validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  validates_attachment_size :picture, :less_than => 3.megabytes
end
