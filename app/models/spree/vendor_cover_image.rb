# == Schema Information
#
# Table name: spree_assets
#
#  id                      :bigint           not null, primary key
#  alt                     :text
#  attachment_content_type :string
#  attachment_file_name    :string
#  attachment_file_size    :integer
#  attachment_height       :integer
#  attachment_updated_at   :datetime
#  attachment_width        :integer
#  position                :integer
#  private_metadata        :jsonb
#  public_metadata         :jsonb
#  type                    :string(75)
#  viewable_type           :string
#  created_at              :datetime
#  updated_at              :datetime
#  viewable_id             :bigint
#
# Indexes
#
#  index_assets_on_viewable_id             (viewable_id)
#  index_assets_on_viewable_type_and_type  (viewable_type,type)
#  index_spree_assets_on_position          (position)
#
module Spree
  class VendorCoverImage < Asset
    include Spree::Image::Configuration::ActiveStorage
    include Rails.application.routes.url_helpers

    def styles
      self.class.styles.map do |_, size|
        width, height = size[/(\d+)x(\d+)/].split('x')

        {
          url: polymorphic_path(attachment.variant(resize: size), only_path: true),
          width: width,
          height: height
        }
      end
    end
  end
end
