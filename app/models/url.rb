class Url < ApplicationRecord
  validates :original_url, :url, presence: true
  validates :url, uniqueness: true
  validates_format_of :original_url,
    with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/

  after_initialize :generate_url, if: :new_record?

  def generate_url
    return if self[:url].present?
    url = generate_key
    loop do
      break unless Url.exists?(url: url)
      url = generate_key
    end
    self[:url] = url
  end

  private

  def generate_key
    SecureRandom.urlsafe_base64.tr('-', '')[0..5]
  end
end
